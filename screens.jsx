/* global React, Icon, ColorIcon, Button, Card, Signal, Dot, Widget, Trend */
const { useState: useStateScr } = React;

// Shared sub-screen header (back + title)
function ScreenHeader({ title, onBack }) {
  return (
    <div style={{
      height: 54, padding: "0 8px 0 6px", display: "flex", alignItems: "center", gap: 6,
      background: "var(--surface-minimal)", borderBottom: "1px solid var(--stroke-minimal)", flexShrink: 0,
    }}>
      <button onClick={onBack} aria-label="Back" style={{
        width: 40, height: 40, borderRadius: 999, border: "none", background: "none", cursor: "pointer",
        display: "flex", alignItems: "center", justifyContent: "center",
      }}>
        <Icon name="arrow_back" size={22} color="var(--content-heavy)" />
      </button>
      <div style={{ fontSize: 17, fontWeight: 800, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>{title}</div>
    </div>
  );
}

// ═══════════════════════════════════════════════════════════════
// APPROVALS SCREEN — functional list
// ═══════════════════════════════════════════════════════════════
function ApprovalsScreen({ onBack, bulkApproved, onBulkApprove, initialFilter }) {
  const seed = [
    { id: "a1", who: "Priya Nair", role: "Backend pod", type: "Leave", detail: "Annual leave · 2–6 Jun (5 days)", low: true, icon: "calendar" },
    { id: "a2", who: "Karan Mehta", role: "Platform", type: "Expense", detail: "Client dinner · ₹4,200", low: true, icon: "card" },
    { id: "a3", who: "Sana Iqbal", role: "Design", type: "Leave", detail: "Sick leave · 31 May (1 day)", low: true, icon: "calendar" },
    { id: "a4", who: "Devansh Roy", role: "QA", type: "Travel", detail: "Offsite · Bengaluru · ₹38,500", low: false, icon: "location" },
    { id: "a5", who: "Meera Joshi", role: "Data", type: "Expense", detail: "GPU credits · ₹74,000", low: false, icon: "card" },
    { id: "a6", who: "Rahul Verma", role: "Platform", type: "Sign-off", detail: "Release 4.2 → production", low: false, icon: "document" },
  ];
  const [items, setItems] = useStateScr(seed.map((s) => ({ ...s, status: (bulkApproved && s.low) ? "approved" : "pending" })));
  const [filter, setFilter] = useStateScr(initialFilter || "All");
  const act = (id, status) => setItems((xs) => xs.map((x) => x.id === id ? { ...x, status } : x));
  const lowPending = items.filter((x) => x.low && x.status === "pending").length;

  const chips = ["All", "Leave", "Travel", "Expense", "Sign-off"];
  const inFilter = (x) => filter === "All" || x.type === filter;
  const visible = items.filter(inFilter);
  const pending = visible.filter((x) => x.status === "pending");
  const reviewed = visible.filter((x) => x.status !== "pending");

  const renderItem = (it) =>
  <Card key={it.id} surface="elev" pad={14}>
      <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
        <span style={{ width: 38, height: 38, borderRadius: 11, background: "var(--surface-subtle)", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}>
          <Icon name={it.icon} size={19} color="var(--content-moderate)" />
        </span>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>{it.who} · <span style={{ color: "var(--content-moderate)", fontWeight: 600 }}>{it.type}</span></div>
          <div style={{ fontSize: 12.5, color: "var(--content-moderate)", marginTop: 2 }}>{it.detail}</div>
        </div>
        {it.low && it.status === "pending" && <Signal tone="info" dot={false}>Low-risk</Signal>}
      </div>
      {it.status === "pending" ?
    <div style={{ display: "flex", gap: 8, marginTop: 12 }}>
          <Button size="s" variant="primary" full onClick={() => act(it.id, "approved")}>Approve</Button>
          <Button size="s" variant="secondary" full onClick={() => act(it.id, "declined")}>Decline</Button>
        </div> :

    <div style={{ marginTop: 11, display: "flex", alignItems: "center", gap: 7 }}>
          <Icon name={it.status === "approved" ? "confirm" : "close"} size={15} color={it.status === "approved" ? "var(--positive)" : "var(--negative)"} />
          <span style={{ fontSize: 13, fontWeight: 700, color: it.status === "approved" ? "var(--positive)" : "var(--negative)" }}>
            {it.status === "approved" ? "Approved" : "Declined"}
          </span>
        </div>
    }
    </Card>;

  const groupHead = (label, n) =>
  <div style={{ fontSize: 13, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".02em", color: "var(--content-moderate)", padding: "2px 2px 9px" }}>{label} · {n}</div>;

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", background: "var(--surface-subtle)" }}>
      <ScreenHeader title="Approvals" onBack={onBack} />
      {/* Filter chips */}
      <div style={{ display: "flex", gap: 8, padding: "12px 16px", overflowX: "auto", background: "var(--surface-minimal)", borderBottom: "1px solid var(--stroke-minimal)", flexShrink: 0 }}>
        {chips.map((c) => {
          const on = filter === c;
          const n = c === "All" ? items.length : items.filter((x) => x.type === c).length;
          return (
            <button key={c} onClick={() => setFilter(c)} style={{ flexShrink: 0, height: 34, padding: "0 14px", borderRadius: 999, cursor: "pointer", fontFamily: "inherit", fontSize: 13, fontWeight: 700, border: "1px solid " + (on ? "transparent" : "var(--stroke-minimal)"), background: on ? "var(--reliance-base)" : "var(--surface-minimal)", color: on ? "#fff" : "var(--content-moderate)", whiteSpace: "nowrap" }}>
              {c} {n > 0 && <span style={{ opacity: on ? .8 : .6, fontVariantNumeric: "tabular-nums" }}>{n}</span>}
            </button>);

        })}
      </div>
      <div style={{ flex: 1, overflow: "auto", padding: "14px 16px 28px" }}>
        {lowPending > 0 &&
        <div style={{ padding: "13px 14px", borderRadius: 14, background: "var(--sky-light)", border: "1px solid var(--sky-border)", marginBottom: 16 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 9 }}>
              <Icon name="ai_sparkle" size={18} color="var(--sky)" />
              <div style={{ fontSize: 14, fontWeight: 700, color: "var(--sky-ink)", flex: 1 }}>{lowPending} low-risk & within policy</div>
            </div>
            <Button variant="sky" size="s" full style={{ marginTop: 11 }} onClick={() => {setItems((xs) => xs.map((x) => x.low && x.status === "pending" ? { ...x, status: "approved" } : x));onBulkApprove && onBulkApprove();}}>
              Approve all {lowPending}
            </Button>
          </div>
        }

        {/* Pending */}
        {pending.length > 0 &&
        <div style={{ marginBottom: reviewed.length ? 20 : 0 }}>
            {groupHead("Pending", pending.length)}
            <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>{pending.map(renderItem)}</div>
          </div>
        }

        {/* Reviewed */}
        {reviewed.length > 0 &&
        <div>
            {groupHead("Reviewed", reviewed.length)}
            <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>{reviewed.map(renderItem)}</div>
          </div>
        }

        {visible.length === 0 &&
        <div style={{ padding: "28px", textAlign: "center", fontSize: 13.5, color: "var(--content-moderate)", fontWeight: 600 }}>Nothing here right now.</div>
        }
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════════════
// TEAM SCREEN
// ═══════════════════════════════════════════════════════════════
function TeamScreen({ onBack }) {
  const [q, setQ] = useStateScr("");
  const [filter, setFilter] = useStateScr("All");
  const groups = [
  { key: "present", label: "Present", tone: "healthy", total: 214, people: [
    { n: "Aarav Kapoor", r: "Backend · in office" },
    { n: "Diya Nair", r: "Design · remote" },
    { n: "Karthik Iyer", r: "Platform · in office" },
    { n: "Sneha Rao", r: "Data · remote" }] },

  { key: "leave", label: "On leave today", tone: "info", total: 22, people: [
    { n: "Arjun Pillai", r: "Backend · planned" },
    { n: "Tanvi Shah", r: "Design · sick" },
    { n: "Imran Khan", r: "Data · planned" }] },

  { key: "notin", label: "Not informed", tone: "risk", total: 14, people: [
    { n: "Rohan Das", r: "QA · expected 9:00" },
    { n: "Nisha Rao", r: "Platform · expected 9:30" }] }];


  const chips = [["All", null], ["Present", "present"], ["On leave", "leave"], ["Not informed", "notin"]];
  const ql = q.trim().toLowerCase();
  const shown = groups.
  filter((g) => filter === "All" || g.key === filter).
  map((g) => ({ ...g, people: g.people.filter((p) => p.n.toLowerCase().includes(ql) || p.r.toLowerCase().includes(ql)) })).
  filter((g) => g.people.length > 0);

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", background: "var(--surface-subtle)" }}>
      <ScreenHeader title="Team" onBack={onBack} />
      {/* Search */}
      <div style={{ padding: "12px 16px 0", background: "var(--surface-minimal)", flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 10, height: 44, borderRadius: 999, border: "1px solid var(--stroke-heavy)", padding: "0 14px" }}>
          <Icon name="search" size={18} color="var(--content-minimal)" />
          <input value={q} onChange={(e) => setQ(e.target.value)} placeholder="Search your team" style={{ flex: 1, border: "none", outline: "none", background: "transparent", fontFamily: "inherit", fontSize: 14, color: "var(--content-heavy)" }} />
          {q &&
          <button onClick={() => setQ("")} aria-label="Clear" style={{ width: 26, height: 26, borderRadius: 999, border: "none", background: "var(--surface-subtle)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}><Icon name="close" size={14} color="var(--content-moderate)" /></button>
          }
        </div>
      </div>
      {/* Filter chips */}
      <div style={{ display: "flex", gap: 8, padding: "12px 16px", overflowX: "auto", background: "var(--surface-minimal)", borderBottom: "1px solid var(--stroke-minimal)", flexShrink: 0 }}>
        {chips.map(([label, key]) => {
          const on = filter === (key || "All") || filter === "All" && label === "All";
          const active = label === "All" ? filter === "All" : filter === key;
          const n = label === "All" ? 250 : groups.find((g) => g.key === key).total;
          return (
            <button key={label} onClick={() => setFilter(label === "All" ? "All" : key)} style={{ flexShrink: 0, height: 34, padding: "0 14px", borderRadius: 999, cursor: "pointer", fontFamily: "inherit", fontSize: 13, fontWeight: 700, border: "1px solid " + (active ? "transparent" : "var(--stroke-minimal)"), background: active ? "var(--reliance-base)" : "var(--surface-minimal)", color: active ? "#fff" : "var(--content-moderate)", whiteSpace: "nowrap" }}>
              {label} <span style={{ opacity: active ? .8 : .6, fontVariantNumeric: "tabular-nums" }}>{n}</span>
            </button>);

        })}
      </div>

      <div style={{ flex: 1, overflow: "auto", padding: "14px 16px 28px" }}>
        {filter === "All" &&
        <Card surface="elev" pad={16}>
            <div style={{ display: "flex", height: 8, borderRadius: 999, overflow: "hidden", gap: 2, marginBottom: 14 }}>
              <span style={{ flex: 214, background: "var(--positive)" }} />
              <span style={{ flex: 22, background: "var(--sky)" }} />
              <span style={{ flex: 14, background: "var(--warning)" }} />
            </div>
            <div style={{ display: "grid", gridTemplateColumns: "repeat(4,1fr)" }}>
              {[["Headcount", 250, "var(--content-heavy)"], ["Present", 214, "var(--positive)"], ["On leave", 22, "var(--sky)"], ["Not in", 14, "var(--warning)"]].map(([l, v, c], i) =>
            <div key={l} style={{ textAlign: "center", borderLeft: i ? "1px solid var(--stroke-minimal)" : "none" }}>
                  <div style={{ fontSize: 24, fontWeight: 900, color: c, fontVariantNumeric: "tabular-nums", letterSpacing: "-.02em", lineHeight: 1 }}>{v}</div>
                  <div style={{ fontSize: 11.5, color: "var(--content-moderate)", fontWeight: 600, marginTop: 5 }}>{l}</div>
                </div>
            )}
            </div>
          </Card>
        }
        {shown.map((g) =>
        <div key={g.key} style={{ marginTop: 18 }}>
            <div style={{ display: "flex", alignItems: "center", gap: 7, padding: "0 2px 9px" }}>
              <Dot tone={g.tone} size={8} />
              <span style={{ fontSize: 13, fontWeight: 700, textTransform: "uppercase", letterSpacing: ".02em", color: "var(--content-moderate)" }}>{g.label} · {g.total}</span>
            </div>
            <Card surface="elev" pad={4}>
              {g.people.map((p, i) =>
            <div key={p.n} style={{ display: "flex", alignItems: "center", gap: 12, padding: "11px 12px", borderTop: i ? "1px solid var(--stroke-minimal)" : "none" }}>
                  <span style={{ width: 36, height: 36, borderRadius: 999, background: "var(--reliance-50)", color: "var(--reliance-base)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 14, fontWeight: 800, flexShrink: 0 }}>{p.n[0]}</span>
                  <div style={{ flex: 1, minWidth: 0 }}>
                    <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)" }}>{p.n}</div>
                    <div style={{ fontSize: 12.5, color: "var(--content-moderate)", marginTop: 1 }}>{p.r}</div>
                  </div>
                </div>
            )}
              {g.people.length < g.total &&
            <div style={{ padding: "10px 12px", borderTop: "1px solid var(--stroke-minimal)", fontSize: 12.5, fontWeight: 600, color: "var(--reliance-base)", cursor: "pointer" }}>Show all {g.total}</div>
            }
            </Card>
          </div>
        )}
        {shown.length === 0 &&
        <div style={{ padding: "28px", textAlign: "center", fontSize: 13.5, color: "var(--content-moderate)", fontWeight: 600 }}>No one matches “{q}”.</div>
        }
      </div>
    </div>);

}

// ═══════════════════════════════════════════════════════════════
// REPORTS SCREEN
// ═══════════════════════════════════════════════════════════════
function ReportsScreen({ onBack }) {
  const bars = [62, 70, 66, 74, 80, 86];
  const metrics = [
    { label: "On-time delivery", value: "86%", trend: "+4 pts", tone: "healthy", good: true },
    { label: "Sprint velocity", value: "92 pts", trend: "+6", tone: "healthy", good: true },
    { label: "Escaped defects", value: "14", trend: "+5", tone: "risk", good: false },
    { label: "Capacity load", value: "113%", trend: "+9%", tone: "off", good: false },
    { label: "Attrition (TTM)", value: "8.1%", trend: "−0.4", tone: "healthy", good: true },
  ];
  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", background: "var(--surface-subtle)" }}>
      <ScreenHeader title="Reports" onBack={onBack} />
      <div style={{ flex: 1, overflow: "auto", padding: "14px 16px 28px" }}>
        <Card surface="elev" pad={18}>
          <div style={{ fontSize: 12.5, color: "var(--content-moderate)", fontWeight: 600 }}>On-time delivery · last 6 weeks</div>
          <div style={{ display: "flex", alignItems: "baseline", gap: 9, marginTop: 6 }}>
            <span style={{ fontSize: 40, fontWeight: 900, letterSpacing: "-.03em", color: "var(--content-heavy)", fontVariantNumeric: "tabular-nums", lineHeight: .9 }}>86%</span>
            <Trend dir="up">+4 pts</Trend>
          </div>
          <div style={{ display: "flex", alignItems: "flex-end", gap: 9, height: 90, marginTop: 18 }}>
            {bars.map((b, i) => (
              <div key={i} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 6 }}>
                <span style={{ width: "100%", height: `${b}%`, borderRadius: 6, background: i === bars.length - 1 ? "var(--reliance-base)" : "var(--reliance-100)" }} />
                <span style={{ fontSize: 10, color: "var(--content-minimal)", fontWeight: 600 }}>W{i + 1}</span>
              </div>
            ))}
          </div>
        </Card>
        <div style={{ marginTop: 16, display: "flex", flexDirection: "column", gap: 10 }}>
          {metrics.map((m) => (
            <Card key={m.label} surface="elev" pad={14}>
              <div style={{ display: "flex", alignItems: "center", gap: 12 }}>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)" }}>{m.label}</div>
                  <div style={{ display: "flex", alignItems: "baseline", gap: 8, marginTop: 4 }}>
                    <span style={{ fontSize: 20, fontWeight: 900, color: "var(--content-heavy)", fontVariantNumeric: "tabular-nums", letterSpacing: "-.02em" }}>{m.value}</span>
                    <Trend dir={m.good ? "up" : "down"} good={m.good}>{m.trend}</Trend>
                  </div>
                </div>
                <Signal tone={m.tone} />
              </div>
            </Card>
          ))}
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { ScreenHeader, ApprovalsScreen, TeamScreen, ReportsScreen });
