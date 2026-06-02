/* global React, Icon, ColorIcon, Button, Card, ScreenHeader */
const { useState: useStateProf } = React;

const JIO_DOT = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 32 32" fill="none" aria-hidden="true"><g clip-path="url(#pjd_clip)"><rect width="32" height="32" rx="16" fill="#000093"></rect><path d="M11.304 9.65h-.534c-1.012 0-1.565.57-1.565 1.712v5.506c0 1.417-.478 1.915-1.602 1.915-.883 0-1.601-.387-2.172-1.087-.055-.073-1.215.479-1.215 1.842 0 1.473 1.38 2.375 3.94 2.375 3.112 0 4.752-1.565 4.752-4.99v-5.56c-.002-1.141-.554-1.713-1.604-1.713zm12.4 2.688c-3.02 0-5.027 1.915-5.027 4.77 0 2.928 1.933 4.807 4.971 4.807 3.02 0 5.008-1.878 5.008-4.788.001-2.874-1.97-4.789-4.952-4.789zm-.037 6.868c-1.18 0-1.989-.865-1.989-2.099 0-1.215.83-2.08 1.989-2.08 1.159 0 1.988.865 1.988 2.099 0 1.196-.846 2.08-1.988 2.08zm-7.542-6.776h-.369c-.901 0-1.582.423-1.582 1.713v5.892c0 1.307.663 1.713 1.62 1.713h.368c.902 0 1.547-.443 1.547-1.713v-5.892c0-1.326-.626-1.713-1.584-1.713zm-.202-4.271c-1.142 0-1.86.645-1.86 1.657 0 1.03.737 1.675 1.915 1.675 1.142 0 1.86-.644 1.86-1.675 0-1.03-.737-1.657-1.915-1.657z" fill="#fff"></path></g></svg>';

// ── Donut chart ──
function Donut({ size = 108, stroke = 15, segments, centerTop, centerBig }) {
  const r = (size - stroke) / 2;
  const c = 2 * Math.PI * r;
  const total = segments.reduce((s, x) => s + x.value, 0) || 1;
  let offset = 0;
  return (
    <div style={{ position: "relative", width: size, height: size, flexShrink: 0 }}>
      <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`}>
        <g transform={`rotate(-90 ${size / 2} ${size / 2})`}>
          <circle cx={size / 2} cy={size / 2} r={r} fill="none" stroke="var(--surface-subtle)" strokeWidth={stroke} />
          {segments.map((seg, i) => {
            const len = c * seg.value / total;
            const el = <circle key={i} cx={size / 2} cy={size / 2} r={r} fill="none" stroke={seg.color} strokeWidth={stroke} strokeDasharray={`${len} ${c - len}`} strokeDashoffset={-offset} />;
            offset += len;
            return el;
          })}
        </g>
      </svg>
      <div style={{ position: "absolute", inset: 0, display: "flex", flexDirection: "column", alignItems: "center", justifyContent: "center" }}>
        {centerTop && <div style={{ fontSize: 11, color: "var(--content-minimal)", fontWeight: 600 }}>{centerTop}</div>}
        <div style={{ fontSize: centerBig.length > 6 ? 16 : 20, fontWeight: 900, color: "var(--content-heavy)", fontVariantNumeric: "tabular-nums", letterSpacing: "-.02em", lineHeight: 1 }}>{centerBig}</div>
      </div>
    </div>);

}

// ── Collapsible section card ──
function Section({ title, open, onToggle, children }) {
  return (
    <Card surface="elev" pad={0} style={{ overflow: "hidden" }}>
      <button onClick={onToggle} style={{ width: "100%", display: "flex", alignItems: "center", gap: 10, padding: "14px 16px", background: "var(--reliance-50)", border: "none", cursor: "pointer", fontFamily: "inherit" }}>
        <span style={{ flex: 1, textAlign: "left", fontSize: 14.5, fontWeight: 800, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>{title}</span>
        <Icon name={open ? "chevron_up" : "chevron_down"} size={20} color="var(--reliance-base)" />
      </button>
      {open && <div style={{ padding: "4px 16px 16px" }}>{children}</div>}
    </Card>);

}

// ── Label / value pair ──
function KV({ label, value, valueColor = "var(--content-heavy)" }) {
  return (
    <div style={{ padding: "9px 0 0" }}>
      <div style={{ fontSize: 12, color: "var(--content-minimal)", fontWeight: 500 }}>{label}</div>
      <div style={{ fontSize: 14, color: valueColor, fontWeight: 700, marginTop: 2, letterSpacing: "-.01em" }}>{value}</div>
    </div>);

}

// ── KV grid (2-up) ──
function KVRow({ items }) {
  return (
    <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "0 16px" }}>
      {items.map((it) => <KV key={it.label} {...it} />)}
    </div>);

}

const AddBtn = ({ onClick, label = "Add" }) =>
<div style={{ display: "flex", justifyContent: "flex-end", marginTop: 14 }}>
    <Button size="s" variant="secondary" icon="add" onClick={onClick}>{label}</Button>
  </div>;


function ProfileScreen({ onBack, onToast }) {
  const [tab, setTab] = useStateProf("prof");
  const [open, setOpen] = useStateProf({ edu: true, work: true, cert: false, perf: false, comp: false, att: false, reimb: false });
  const toggle = (k) => setOpen((o) => ({ ...o, [k]: !o[k] }));
  const t = (m) => onToast && onToast(m);

  return (
    <div style={{ display: "flex", flexDirection: "column", height: "100%", background: "var(--surface-subtle)" }}>
      {/* Header */}
      <div style={{ height: 54, padding: "0 6px", display: "flex", alignItems: "center", gap: 4, background: "var(--surface-minimal)", borderBottom: "1px solid var(--stroke-minimal)", flexShrink: 0 }}>
        <button onClick={onBack} aria-label="Back" style={{ width: 40, height: 40, borderRadius: 999, border: "none", background: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Icon name="arrow_back" size={22} color="var(--content-heavy)" />
        </button>
        <div style={{ flex: 1, fontSize: 17, fontWeight: 800, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>My profile</div>
        <button onClick={() => t("Settings")} aria-label="Settings" style={{ width: 40, height: 40, borderRadius: 999, border: "none", background: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Icon name="settings" size={21} color="var(--content-heavy)" />
        </button>
        <button onClick={() => t("More options")} aria-label="More" style={{ width: 40, height: 40, borderRadius: 999, border: "none", background: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Icon name="more_horizontal" size={21} color="var(--content-heavy)" />
        </button>
      </div>

      <div style={{ flex: 1, overflow: "auto" }}>
        <div style={{ padding: "14px 16px 28px", display: "flex", flexDirection: "column", gap: 12 }}>
        {/* ID card */}
        <Card surface="elev" pad={0} style={{ overflow: "hidden" }}>
          <div style={{ position: "relative", background: "var(--reliance-50)", backgroundImage: "radial-gradient(var(--reliance-200) 1.4px, transparent 1.4px)", backgroundSize: "11px 11px", display: "flex", flexDirection: "column", alignItems: "center", padding: "22px 16px 18px" }}>
            <span style={{ position: "absolute", top: 12, left: 14, width: 26, height: 26, lineHeight: 0 }} dangerouslySetInnerHTML={{ __html: JIO_DOT }} />
            <span style={{ width: 84, height: 84, borderRadius: 999, background: "var(--reliance-base)", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 30, fontWeight: 800, border: "4px solid var(--surface-minimal)", letterSpacing: ".02em", boxShadow: "var(--shadow-elevated-low)" }}>PS</span>
            <div style={{ fontSize: 19, fontWeight: 800, color: "var(--content-heavy)", marginTop: 12, letterSpacing: "-.01em" }}>Priya Sharma</div>
            <div style={{ fontSize: 13.5, color: "var(--content-moderate)", fontWeight: 500, marginTop: 2 }}>Senior Designer · Design</div>
            <div style={{ fontSize: 12.5, color: "var(--content-minimal)", fontWeight: 600, marginTop: 3, fontVariantNumeric: "tabular-nums" }}>Employee ID · 55043898</div>
            <div style={{ display: "flex", gap: 12, marginTop: 14 }}>
              {[["send_message", "Email"], ["call", "Call"], ["id", "Card"]].map(([ic, lbl]) =>
              <button key={lbl} onClick={() => t(lbl)} aria-label={lbl} style={{ width: 42, height: 42, borderRadius: 999, border: "1px solid var(--stroke-minimal)", background: "var(--surface-minimal)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer" }}>
                  <Icon name={ic} size={19} color="var(--reliance-base)" />
                </button>
              )}
            </div>
          </div>
        </Card>

        {/* Contact card */}
        <Card surface="elev" pad={16}>
          <KV label="Email ID" value="priya.sharma@ril.com" />
          <div style={{ display: "flex", alignItems: "flex-end", justifyContent: "space-between", borderTop: "1px solid var(--stroke-minimal)", marginTop: 11, paddingTop: 2 }}>
            <KV label="Phone" value="+91 99009 90099" />
            <div style={{ display: "flex", gap: 8, paddingBottom: 2 }}>
              <button onClick={() => t("Call Priya")} aria-label="Call" style={contactMini}><Icon name="call" size={17} color="var(--positive)" /></button>
            </div>
          </div>
          <div style={{ borderTop: "1px solid var(--stroke-minimal)", marginTop: 11 }}>
            <KVRow items={[{ label: "Gender", value: "Female" }, { label: "Date of birth", value: "14 Mar 1994" }]} />
          </div>
          <div style={{ borderTop: "1px solid var(--stroke-minimal)", marginTop: 13, paddingTop: 11 }}>
            <div style={{ fontSize: 13, fontWeight: 800, color: "var(--content-heavy)" }}>Emergency contact</div>
            {[["Mahesh Sharma", "Father · +91 98291 10291"], ["Riya Shah", "Sister · +91 87291 10123"]].map(([n, d], i) =>
            <div key={n} style={{ display: "flex", alignItems: "center", gap: 10, padding: "11px 0 0" }}>
                <div style={{ flex: 1 }}>
                  <div style={{ fontSize: 14, fontWeight: 700, color: "var(--content-heavy)" }}>{n}</div>
                  <div style={{ fontSize: 12, color: "var(--content-moderate)", marginTop: 1 }}>{d}</div>
                </div>
                <button onClick={() => t("Call " + n)} aria-label={"Call " + n} style={contactMini}><Icon name="call" size={17} color="var(--positive)" /></button>
              </div>
            )}
          </div>
        </Card>

        {/* Tabs */}
        <div style={{ display: "flex", gap: 8, background: "var(--surface-minimal)", border: "1px solid var(--stroke-minimal)", borderRadius: 999, padding: 4 }}>
          {[["prof", "Professional details"], ["org", "Organisation details"]].map(([id, lbl]) =>
          <button key={id} onClick={() => setTab(id)} style={{ flex: 1, height: 38, borderRadius: 999, cursor: "pointer", fontFamily: "inherit", fontSize: 13, fontWeight: 700, border: "none", background: tab === id ? "var(--reliance-base)" : "transparent", color: tab === id ? "#fff" : "var(--content-moderate)" }}>{lbl}</button>
          )}
        </div>

        {tab === "prof" ? <ProfessionalTab open={open} toggle={toggle} t={t} /> : <OrgTab />}
        </div>
      </div>
    </div>);

}

const contactMini = { width: 36, height: 36, borderRadius: 999, border: "1px solid var(--stroke-minimal)", background: "var(--surface-minimal)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", flexShrink: 0 };

// ═══════════════ Professional tab ═══════════════
function ProfessionalTab({ open, toggle, t }) {
  return (
    <React.Fragment>
      {/* Education */}
      <Section title="Education details" open={open.edu} onToggle={() => toggle("edu")}>
        <EduItem icon="R" badge="var(--reliance-base)" degree="Master of Design (M.Des.)" tag="Post graduation"
          rows={[["Branch of study", "Design"], ["University", "IIT Delhi"], ["Course type", "Full time"], ["From", "Aug 2015"], ["To", "May 2017"], ["Score", "79.2%"]]} />
        <div style={{ borderTop: "1px solid var(--stroke-minimal)", marginTop: 14, paddingTop: 4 }} />
        <EduItem icon="B" badge="var(--sparkle)" degree="Bachelor of Design (B.Des.)" tag="Graduation"
          rows={[["Branch of study", "Design"], ["University", "IIT Delhi"], ["Course type", "Full time"], ["From", "Aug 2012"], ["To", "May 2015"], ["Score", "86.9%"]]} />
        <AddBtn onClick={() => t("Add education")} />
      </Section>

      {/* Work experiences */}
      <Section title="Work experiences" open={open.work} onToggle={() => toggle("work")}>
        <Company logo="jio" name="Reliance Jio" span="4 yrs 1 month" roles={[["Senior Designer", "Oct 2021 – Present · 3 yrs 7 months"], ["UI/UX Designer", "Jul 2021 – Oct 2021 · 3 months"]]} />
        <div style={{ borderTop: "1px solid var(--stroke-minimal)", marginTop: 14, paddingTop: 14 }} />
        <Company logo="M" logoBg="oklch(60% 0.02 264)" name="Microsoft" span="6 months" roles={[["Design Trainee", "Jan 2021 – Jun 2021 · 6 months"]]} />
        <AddBtn onClick={() => t("Add experience")} />
      </Section>

      {/* Certificates */}
      <Section title="Certificates" open={open.cert} onToggle={() => toggle("cert")}>
        <div style={{ display: "flex", gap: 11 }}>
          <span style={{ width: 38, height: 38, borderRadius: 10, background: "var(--reliance-50)", display: "flex", alignItems: "center", justifyContent: "center", flexShrink: 0 }}><Icon name="document" size={20} color="var(--reliance-base)" /></span>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 11.5, color: "var(--content-minimal)", fontWeight: 600 }}>Certificate</div>
            <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>Introduction to Generative AI</div>
          </div>
        </div>
        <KVRow items={[{ label: "Platform", value: "Coursera" }, { label: "Course type", value: "Online" }]} />
        <KVRow items={[{ label: "Issued on", value: "Aug 2023" }, { label: "Score", value: "79.2%" }]} />
        <KV label="Certificate number" value="Z675542" />
        <button onClick={() => t("Opening certificate")} style={{ marginTop: 12, background: "none", border: "none", padding: 0, cursor: "pointer", fontFamily: "inherit", fontSize: 13.5, fontWeight: 700, color: "var(--reliance-base)" }}>View certificate</button>
        <AddBtn onClick={() => t("Add certificate")} />
      </Section>

      {/* Performance rating */}
      <Section title="Performance details (rating)" open={open.perf} onToggle={() => toggle("perf")}>
        {[["2023–2024", "A*"], ["2022–2023", "A+"], ["2021–2022", "A+"]].map(([yr, r], i) =>
        <div key={yr} style={{ display: "flex", alignItems: "center", gap: 12, padding: "12px 0", borderTop: i ? "1px solid var(--stroke-minimal)" : "none" }}>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 13, color: "var(--content-moderate)", fontWeight: 600 }}>{yr}</div>
              <div style={{ fontSize: 16, fontWeight: 900, color: "var(--content-heavy)", marginTop: 2 }}>Rating {r}</div>
            </div>
            <button onClick={() => t("Viewing " + yr + " review")} style={pillLink}>View</button>
          </div>
        )}
      </Section>

      {/* Compensation */}
      <Section title="Compensation details" open={open.comp} onToggle={() => toggle("comp")}>
        {[
        ["Promotion without CTC", "04 May 2021", "₹0.00", "₹1,92,000"],
        ["Revision with VPLI", "04 May 2021", "₹0.00", "₹1,92,000"],
        ["Comp & adv. (as applicable)", "04 May 2021", "₹0.00", "₹1,92,000"]].
        map(([title, date, bonus, inc], i) =>
        <div key={title} style={{ paddingTop: i ? 14 : 4, marginTop: i ? 14 : 0, borderTop: i ? "1px solid var(--stroke-minimal)" : "none" }}>
            <div style={{ fontSize: 14, fontWeight: 800, color: "var(--content-heavy)" }}>{title}</div>
            <KVRow items={[{ label: "Effective date", value: date }, { label: "Bonus", value: bonus }]} />
            <KV label="Increment (in ₹ PA)" value={inc} />
            <button onClick={() => t("Opening letter")} style={{ marginTop: 10, display: "inline-flex", alignItems: "center", gap: 6, background: "none", border: "none", padding: 0, cursor: "pointer", fontFamily: "inherit", fontSize: 13.5, fontWeight: 700, color: "var(--reliance-base)" }}>
              <Icon name="document" size={16} color="var(--reliance-base)" />View letter
            </button>
          </div>
        )}
      </Section>

      {/* Attendance insights */}
      <Section title="Attendance insights" open={open.att} onToggle={() => toggle("att")}>
        <div style={{ fontSize: 12.5, fontWeight: 700, color: "var(--content-moderate)", marginTop: 4 }}>2024–25</div>
        <div style={{ display: "flex", alignItems: "center", gap: 18, marginTop: 10 }}>
          <Donut segments={[{ value: 200, color: "var(--positive)" }, { value: 23, color: "var(--warning)" }]} centerTop="Total" centerBig="223" />
          <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 12 }}>
            <Legend color="var(--positive)" label="Days present" value="200" pct="90%" />
            <Legend color="var(--warning)" label="Days absent" value="23" pct="10%" />
          </div>
        </div>
        <div style={{ fontSize: 11.5, color: "var(--content-minimal)", marginTop: 14, lineHeight: 1.4 }}>Note: Logged hours 1600 / 1760</div>
      </Section>

      {/* Reimbursement */}
      <Section title="Reimbursement summary" open={open.reimb} onToggle={() => toggle("reimb")}>
        <div style={{ display: "flex", gap: 8, marginTop: 4, marginBottom: 6 }}>
          {["2024–25", "2023–24", "2022–23"].map((y, i) =>
          <span key={y} style={{ height: 30, padding: "0 14px", borderRadius: 999, display: "inline-flex", alignItems: "center", fontSize: 12.5, fontWeight: 700, background: i === 0 ? "var(--reliance-base)" : "var(--surface-minimal)", color: i === 0 ? "#fff" : "var(--content-moderate)", border: "1px solid " + (i === 0 ? "transparent" : "var(--stroke-minimal)") }}>{y}</span>
          )}
        </div>
        <div style={{ display: "flex", alignItems: "center", gap: 18, marginTop: 10 }}>
          <Donut segments={[{ value: 80, color: "var(--reliance-base)" }, { value: 20, color: "var(--reliance-200)" }]} centerTop="Claims" centerBig="₹1,00,000" />
          <div style={{ flex: 1, display: "flex", flexDirection: "column", gap: 12 }}>
            <Legend color="var(--reliance-base)" label="Direct" value="₹80,000" pct="80%" />
            <Legend color="var(--reliance-200)" label="Roll up" value="₹20,000" pct="20%" />
          </div>
        </div>
        <div style={{ fontSize: 11.5, color: "var(--content-minimal)", marginTop: 14, lineHeight: 1.4 }}>Note: Amount calculated based on payment-processed claims.</div>
      </Section>
    </React.Fragment>);

}

function Legend({ color, label, value, pct }) {
  return (
    <div style={{ display: "flex", alignItems: "center", gap: 9 }}>
      <span style={{ width: 10, height: 10, borderRadius: 3, background: color, flexShrink: 0 }} />
      <span style={{ fontSize: 13, color: "var(--content-moderate)", fontWeight: 600, flex: 1 }}>{label}</span>
      <span style={{ fontSize: 14, fontWeight: 800, color: "var(--content-heavy)", fontVariantNumeric: "tabular-nums" }}>{value}</span>
      <span style={{ fontSize: 12, color: "var(--content-minimal)", fontWeight: 600, width: 34, textAlign: "right" }}>{pct}</span>
    </div>);

}

const pillLink = { height: 32, padding: "0 16px", borderRadius: 999, border: "1px solid var(--stroke-heavy)", background: "var(--surface-minimal)", cursor: "pointer", fontFamily: "inherit", fontSize: 13, fontWeight: 700, color: "var(--reliance-base)" };

function EduItem({ degree, tag, rows, icon, badge }) {
  return (
    <div>
      <div style={{ display: "flex", gap: 11, alignItems: "center" }}>
        <span style={{ width: 38, height: 38, borderRadius: 10, background: badge, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16, fontWeight: 800, flexShrink: 0 }}>{icon}</span>
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 11.5, color: "var(--content-minimal)", fontWeight: 600 }}>{tag}</div>
          <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>{degree}</div>
        </div>
      </div>
      <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: "0 16px" }}>
        {rows.map(([l, v]) => <KV key={l} label={l} value={v} />)}
      </div>
    </div>);

}

function Company({ logo, logoBg = "var(--reliance-base)", name, span, roles }) {
  return (
    <div>
      <div style={{ display: "flex", gap: 11, alignItems: "center" }}>
        {logo === "jio" ?
        <span style={{ width: 38, height: 38, lineHeight: 0, flexShrink: 0 }} dangerouslySetInnerHTML={{ __html: JIO_DOT }} /> :
        <span style={{ width: 38, height: 38, borderRadius: 10, background: logoBg, color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 17, fontWeight: 800, flexShrink: 0 }}>{logo}</span>
        }
        <div style={{ flex: 1 }}>
          <div style={{ fontSize: 15, fontWeight: 800, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>{name}</div>
          <div style={{ fontSize: 12, color: "var(--content-moderate)", marginTop: 1 }}>{span}</div>
        </div>
      </div>
      <div style={{ marginTop: 6, paddingLeft: 49 }}>
        {roles.map(([r, d], i) =>
        <div key={r} style={{ position: "relative", padding: "8px 0 8px 16px" }}>
            <span style={{ position: "absolute", left: 0, top: 13, width: 8, height: 8, borderRadius: 999, background: "var(--reliance-base)" }} />
            {i < roles.length && <span style={{ position: "absolute", left: 3.5, top: 13, bottom: -8, width: 1, background: "var(--stroke-minimal)" }} />}
            <div style={{ fontSize: 13.5, fontWeight: 700, color: "var(--content-heavy)" }}>{r}</div>
            <div style={{ fontSize: 12, color: "var(--content-moderate)", marginTop: 1 }}>{d}</div>
          </div>
        )}
      </div>
    </div>);

}

// ═══════════════ Organisation tab ═══════════════
function OrgTab() {
  return (
    <React.Fragment>
      <Card surface="elev" pad={16}>
        <div style={{ fontSize: 13, fontWeight: 800, color: "var(--content-heavy)", marginBottom: 4 }}>Reporting manager</div>
        <div style={{ display: "flex", alignItems: "center", gap: 12, marginTop: 8 }}>
          <span style={{ width: 44, height: 44, borderRadius: 999, background: "var(--reliance-base)", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 15, fontWeight: 800, flexShrink: 0 }}>VM</span>
          <div style={{ flex: 1 }}>
            <div style={{ fontSize: 14.5, fontWeight: 700, color: "var(--content-heavy)" }}>Vikram Menon</div>
            <div style={{ fontSize: 12.5, color: "var(--content-moderate)", marginTop: 1 }}>VP, Engineering & Delivery</div>
          </div>
          <Icon name="chevron_right" size={18} color="var(--content-minimal)" />
        </div>
      </Card>
      <Card surface="elev" pad={16}>
        <KVRow items={[{ label: "Department", value: "Design" }, { label: "Sub-department", value: "Product Design" }]} />
        <KVRow items={[{ label: "Employment type", value: "Full-time" }, { label: "Band / grade", value: "M2" }]} />
        <KVRow items={[{ label: "Date of joining", value: "12 Jul 2021" }, { label: "Cost centre", value: "DSGN-04" }]} />
        <KV label="Work location" value="Mumbai · RCP, Ghansoli" />
      </Card>
      <Card surface="elev" pad={16}>
        <div style={{ fontSize: 13, fontWeight: 800, color: "var(--content-heavy)", marginBottom: 2 }}>Team</div>
        {[["Aanya Verma", "Product Designer"], ["Karan Mehta", "Design Technologist"], ["Sana Iqbal", "UX Researcher"]].map(([n, r], i) =>
        <div key={n} style={{ display: "flex", alignItems: "center", gap: 12, padding: "11px 0 0" }}>
            <span style={{ width: 36, height: 36, borderRadius: 999, background: "var(--reliance-50)", color: "var(--reliance-base)", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 13, fontWeight: 800, flexShrink: 0 }}>{n[0]}</span>
            <div style={{ flex: 1 }}>
              <div style={{ fontSize: 14, fontWeight: 700, color: "var(--content-heavy)" }}>{n}</div>
              <div style={{ fontSize: 12, color: "var(--content-moderate)", marginTop: 1 }}>{r}</div>
            </div>
          </div>
        )}
      </Card>
    </React.Fragment>);

}

Object.assign(window, { ProfileScreen });
