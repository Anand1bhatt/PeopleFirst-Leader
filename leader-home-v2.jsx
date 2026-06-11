/* global React, Icon */
// ═══════════════════════════════════════════════════════════════
// PeopleFirst Leader Home — V2  (dark executive dashboard)
// Zero visual overlap with the main branch design.
// ═══════════════════════════════════════════════════════════════
const { useState, useEffect, useRef } = React;

// ── Palette ─────────────────────────────────────────────────────
const D = {
  bg:        "#07111F",   // deep navy
  surface:   "#0E1C2E",   // card surface
  surfaceHi: "#142436",   // elevated surface
  border:    "rgba(255,255,255,.07)",
  teal:      "#00C4B0",   // primary accent
  tealDim:   "#00C4B015", // ghost tint
  amber:     "#FFB347",
  red:       "#FF5B5B",
  green:     "#4ADEAE",
  text:      "#FFFFFF",
  textMed:   "rgba(255,255,255,.65)",
  textMut:   "rgba(255,255,255,.35)",
  white10:   "rgba(255,255,255,.10)",
  white6:    "rgba(255,255,255,.06)",
};

// ── Helper ───────────────────────────────────────────────────────
function fmt(n) { return n >= 1e7 ? (n/1e7).toFixed(1)+"Cr" : n >= 1e5 ? (n/1e5).toFixed(0)+"L" : n >= 1e3 ? (n/1e3).toFixed(0)+"K" : String(n); }

// ── Top status bar ────────────────────────────────────────────────
function V2StatusBar({ onBell, onProfile, badge, name, initials }) {
  const now = new Date();
  const day = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"][now.getDay()];
  const mon = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"][now.getMonth()];
  const label = `${day}, ${now.getDate()} ${mon}`;
  return (
    <div style={{ display:"flex", alignItems:"center", padding:"14px 20px 0" }}>
      <div style={{ flex:1 }}>
        <div style={{ fontSize:12, fontWeight:600, color:D.textMut, letterSpacing:".04em", textTransform:"uppercase" }}>{label}</div>
      </div>
      <button onClick={onBell} style={{ position:"relative", background:"none", border:"none", cursor:"pointer", width:40, height:40, borderRadius:999, display:"flex", alignItems:"center", justifyContent:"center" }}>
        <Icon name="notification" size={21} color={D.textMed} />
        {badge > 0 && <span style={{ position:"absolute", top:8, right:8, width:7, height:7, borderRadius:999, background:D.red, border:"1.5px solid "+D.bg }} />}
      </button>
      <button onClick={onProfile} style={{ width:38, height:38, borderRadius:999, background:"linear-gradient(135deg,#1B4FD8,#0D8DCF)", border:"none", display:"flex", alignItems:"center", justifyContent:"center", fontSize:15, fontWeight:800, color:"#fff", cursor:"pointer", flexShrink:0, marginLeft:4 }}>{initials}</button>
    </div>
  );
}

// ── Hero greeting + pulse ring ───────────────────────────────────
function V2Hero({ name, pending }) {
  return (
    <div style={{ padding:"24px 20px 20px" }}>
      <div style={{ fontSize:13, fontWeight:600, color:D.teal, letterSpacing:".05em", textTransform:"uppercase", marginBottom:6 }}>Leader Dashboard</div>
      <h1 style={{ margin:0, fontSize:28, fontWeight:300, color:D.text, letterSpacing:"-.02em", lineHeight:1.15 }}>
        Good morning,<br/><strong style={{ fontWeight:800 }}>{name}</strong>
      </h1>
      {pending > 0 && (
        <div style={{ display:"inline-flex", alignItems:"center", gap:8, marginTop:14, padding:"8px 14px", borderRadius:999, background:"rgba(255,91,91,.12)", border:"1px solid rgba(255,91,91,.25)" }}>
          <span style={{ width:7, height:7, borderRadius:999, background:D.red, display:"block", animation:"dotPop .5s ease .3s both" }} />
          <span style={{ fontSize:13.5, fontWeight:700, color:D.red }}>{pending} actions need your attention</span>
        </div>
      )}
    </div>
  );
}

// ── Horizontal KPI strip ──────────────────────────────────────────
function V2KPIStrip() {
  const kpis = [
    { val:"23",  label:"Pending",    unit:"",   color:D.red   },
    { val:"59",  label:"Projects",   unit:"",   color:D.teal  },
    { val:"87%", label:"Attendance", unit:"",   color:D.green },
    { val:"₹42L",label:"Budget left",unit:"",   color:D.amber },
    { val:"14",  label:"Open roles", unit:"",   color:D.textMed },
  ];
  return (
    <div style={{ overflowX:"auto", display:"flex", gap:10, padding:"0 20px 4px", scrollbarWidth:"none" }}>
      {kpis.map((k,i) => (
        <div key={i} style={{ flexShrink:0, padding:"13px 18px", borderRadius:16, background:D.surface, border:"1px solid "+D.border, minWidth:88, animation:`slideUp .4s ease ${.08*i+.1}s both` }}>
          <div style={{ fontSize:22, fontWeight:900, color:k.color, letterSpacing:"-.02em", lineHeight:1 }}>{k.val}</div>
          <div style={{ fontSize:11, fontWeight:600, color:D.textMut, marginTop:5, textTransform:"uppercase", letterSpacing:".04em", whiteSpace:"nowrap" }}>{k.label}</div>
        </div>
      ))}
    </div>
  );
}

// ── Tab bar ───────────────────────────────────────────────────────
function V2Tabs({ active, onChange }) {
  const tabs = ["Overview","Projects","People","Finance"];
  return (
    <div style={{ display:"flex", gap:6, padding:"16px 20px 0", overflowX:"auto", scrollbarWidth:"none" }}>
      {tabs.map(t => {
        const on = active === t;
        return (
          <button key={t} onClick={() => onChange(t)} style={{
            flexShrink:0, padding:"7px 16px", borderRadius:999,
            border: on ? "none" : "1px solid "+D.border,
            background: on ? D.teal : "transparent",
            color: on ? "#000" : D.textMed,
            fontSize:13, fontWeight:on?800:600, cursor:"pointer", fontFamily:"inherit",
            transition:"all .2s ease",
          }}>{t}</button>
        );
      })}
    </div>
  );
}

// ── Section: Overview ─────────────────────────────────────────────
function OverviewSection({ onApprove, flash }) {
  const decisions = [
    { id:"d1", icon:"💰", title:"Rajeev Sharma — Retention Offer", sub:"₹5L off-cycle increment · within approved range", urgency:"high", time:"Awaiting" },
    { id:"d2", icon:"🔑", title:"OFFICE365 licence renewal", sub:"₹14L · Finance & Legal cleared · 7 days left", urgency:"med", time:"7 days" },
  ];
  const [done, setDone] = useState([]);
  const act = (id, label) => { setDone(d => [...d, id]); flash(label); };

  const rows = decisions.filter(d => !done.includes(d.id));

  return (
    <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
      {/* Decisions */}
      <SectionLabel icon="⚡" text="Quick Decisions" count={rows.length} />
      {rows.length === 0 && (
        <div style={{ padding:"20px", textAlign:"center", color:D.textMut, fontSize:13, fontWeight:600 }}>All clear — nothing pending</div>
      )}
      {rows.map(d => (
        <div key={d.id} style={{ padding:"16px", borderRadius:18, background:D.surface, border:"1px solid "+D.border, animation:"slideUp .35s ease both" }}>
          <div style={{ display:"flex", alignItems:"flex-start", gap:12 }}>
            <div style={{ width:40, height:40, borderRadius:14, background:D.white10, display:"flex", alignItems:"center", justifyContent:"center", fontSize:20, flexShrink:0 }}>{d.icon}</div>
            <div style={{ flex:1, minWidth:0 }}>
              <div style={{ fontSize:14, fontWeight:800, color:D.text, marginBottom:3 }}>{d.title}</div>
              <div style={{ fontSize:12.5, color:D.textMed, lineHeight:1.4 }}>{d.sub}</div>
            </div>
            <span style={{ fontSize:11, fontWeight:700, color: d.urgency==="high" ? D.red : D.amber, background: d.urgency==="high"?"rgba(255,91,91,.12)":"rgba(255,179,71,.12)", padding:"3px 8px", borderRadius:999, flexShrink:0 }}>{d.time}</span>
          </div>
          <div style={{ display:"flex", gap:8, marginTop:14 }}>
            <button onClick={() => act(d.id, "Approved ✓")} style={{ flex:1, height:38, borderRadius:12, background:D.teal, color:"#000", border:"none", fontFamily:"inherit", fontWeight:800, fontSize:13.5, cursor:"pointer" }}>Approve</button>
            <button onClick={() => act(d.id, "Opened for review")} style={{ flex:1, height:38, borderRadius:12, background:D.white10, color:D.textMed, border:"1px solid "+D.border, fontFamily:"inherit", fontWeight:700, fontSize:13.5, cursor:"pointer" }}>Review</button>
          </div>
        </div>
      ))}

      {/* AI signal strip */}
      <SectionLabel icon="✦" text="AI Signals" />
      <div style={{ display:"flex", flexDirection:"column", gap:6 }}>
        {[
          { dot:D.red,   msg:"3 sprint blockers detected in Jio Payments rewrite" },
          { dot:D.amber, msg:"2 team members showing disengagement signals this week" },
          { dot:D.green, msg:"Attendance above 90% for 3rd consecutive week" },
        ].map((s,i) => (
          <div key={i} style={{ display:"flex", alignItems:"center", gap:12, padding:"12px 14px", borderRadius:14, background:D.white6, border:"1px solid "+D.border }}>
            <span style={{ width:8, height:8, borderRadius:999, background:s.dot, flexShrink:0 }} />
            <span style={{ fontSize:13.5, fontWeight:600, color:D.textMed, lineHeight:1.4 }}>{s.msg}</span>
          </div>
        ))}
      </div>
    </div>
  );
}

// ── Section: Projects ─────────────────────────────────────────────
function ProjectsSection({ flash }) {
  const projects = [
    { name:"MyJio App",          pct:74, delta:-12, status:"Critical", color:D.red   },
    { name:"MyJio 3.1 Revamp",   pct:61, delta:-5,  status:"Delayed",  color:D.amber },
    { name:"Jio Translate",      pct:82, delta:-3,  status:"Delayed",  color:D.amber },
    { name:"Jio Cloud Infra",    pct:90, delta:+4,  status:"On Track", color:D.green },
    { name:"HR Analytics v3",    pct:55, delta:+2,  status:"On Track", color:D.green },
  ];
  return (
    <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
      <SectionLabel icon="📐" text="Projects" count={59} sub="3 critical" subColor={D.red} />
      {projects.map((p,i) => (
        <div key={i} onClick={() => flash("Opening "+p.name)} style={{ padding:"14px 16px", borderRadius:18, background:D.surface, border:"1px solid "+D.border, cursor:"pointer", animation:`slideUp .3s ease ${.06*i}s both` }}>
          <div style={{ display:"flex", alignItems:"center", gap:10, marginBottom:10 }}>
            <div style={{ flex:1 }}>
              <div style={{ fontSize:14.5, fontWeight:800, color:D.text }}>{p.name}</div>
            </div>
            <span style={{ fontSize:11, fontWeight:800, color:p.color, background:p.color+"18", padding:"3px 10px", borderRadius:999 }}>{p.status}</span>
          </div>
          {/* Progress bar */}
          <div style={{ height:4, borderRadius:999, background:D.white10, overflow:"hidden" }}>
            <div className="anim-bar" style={{ height:"100%", width:p.pct+"%", borderRadius:999, background:p.color }} />
          </div>
          <div style={{ display:"flex", justifyContent:"space-between", marginTop:7 }}>
            <span style={{ fontSize:12, color:D.textMut, fontWeight:600 }}>{p.pct}% complete</span>
            <span style={{ fontSize:12, fontWeight:700, color: p.delta<0 ? D.red : D.green }}>{p.delta>0?"+":""}{p.delta}% this week</span>
          </div>
        </div>
      ))}
    </div>
  );
}

// ── Section: People ────────────────────────────────────────────────
function PeopleSection({ flash }) {
  const bands = [
    { label:"Present", val:203, pct:71, color:D.green  },
    { label:"WFH",     val:34,  pct:12, color:D.teal   },
    { label:"Leave",   val:26,  pct:9,  color:D.amber  },
    { label:"Absent",  val:23,  pct:8,  color:D.red    },
  ];
  const members = [
    { name:"Rajeev Sharma",  role:"Sr. Engineer",   avatar:10, flag:"⚠️", flagColor:D.amber },
    { name:"Neha Joshi",     role:"Product Lead",   avatar:45, flag:"🔥", flagColor:D.red   },
    { name:"Arun Pillai",    role:"Design Mgr",     avatar:32, flag:null,  flagColor:""     },
    { name:"Divya Nair",     role:"Data Analyst",   avatar:25, flag:null,  flagColor:""     },
  ];
  return (
    <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
      <SectionLabel icon="👥" text="Team Presence" sub="Today · 286 total" />
      {/* Stacked bar */}
      <div style={{ borderRadius:18, background:D.surface, border:"1px solid "+D.border, padding:"18px 16px" }}>
        <div style={{ display:"flex", height:12, borderRadius:999, overflow:"hidden", gap:2, marginBottom:16 }}>
          {bands.map((b,i) => (
            <div key={i} className="presence-seg" style={{ flex:b.pct, background:b.color, borderRadius:999, minWidth:0 }} />
          ))}
        </div>
        <div style={{ display:"grid", gridTemplateColumns:"1fr 1fr", gap:"10px 18px" }}>
          {bands.map((b,i) => (
            <div key={i} style={{ display:"flex", alignItems:"center", gap:8 }}>
              <span style={{ width:9, height:9, borderRadius:999, background:b.color, flexShrink:0 }} />
              <span style={{ fontSize:12.5, color:D.textMed, fontWeight:600 }}>{b.label}</span>
              <span style={{ fontSize:13, fontWeight:800, color:D.text, marginLeft:"auto" }}>{b.val}</span>
            </div>
          ))}
        </div>
      </div>
      <SectionLabel icon="🔖" text="Spotlight" />
      {members.map((m,i) => (
        <div key={i} onClick={() => flash("Opening profile: "+m.name)} style={{ display:"flex", alignItems:"center", gap:12, padding:"12px 16px", borderRadius:16, background:D.surface, border:"1px solid "+D.border, cursor:"pointer", animation:`slideUp .3s ease ${.06*i}s both` }}>
          <img src={`https://i.pravatar.cc/52?img=${m.avatar}`} alt="" style={{ width:42, height:42, borderRadius:999, objectFit:"cover", flexShrink:0 }} />
          <div style={{ flex:1 }}>
            <div style={{ fontSize:14, fontWeight:800, color:D.text }}>{m.name}</div>
            <div style={{ fontSize:12, color:D.textMut, marginTop:2 }}>{m.role}</div>
          </div>
          {m.flag && <span style={{ fontSize:17 }}>{m.flag}</span>}
        </div>
      ))}
    </div>
  );
}

// ── Section: Finance ──────────────────────────────────────────────
function FinanceSection({ flash }) {
  const cats = [
    { label:"Payroll",    spent:6820, budget:7200, color:"#4F8EF7" },
    { label:"Ops & IT",   spent:3140, budget:4000, color:D.teal    },
    { label:"Travel",     spent:910,  budget:800,  color:D.red     },
    { label:"Compliance", spent:440,  budget:600,  color:D.amber   },
    { label:"Training",   spent:320,  budget:500,  color:D.green   },
  ];
  return (
    <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
      <SectionLabel icon="💹" text="Budget Overview" sub="Q2 FY26" />
      <div style={{ borderRadius:18, background:D.surface, border:"1px solid "+D.border, padding:"18px 16px" }}>
        <div style={{ marginBottom:16 }}>
          <div style={{ fontSize:11, fontWeight:700, color:D.textMut, textTransform:"uppercase", letterSpacing:".05em" }}>Total spent vs budget</div>
          <div style={{ fontSize:26, fontWeight:900, color:D.text, marginTop:4 }}>₹<span style={{ color:D.teal }}>116L</span> <span style={{ fontSize:16, fontWeight:500, color:D.textMut }}>/ ₹158L</span></div>
        </div>
        <div style={{ display:"flex", flexDirection:"column", gap:10 }}>
          {cats.map((c,i) => {
            const pct = Math.min(c.spent/c.budget*100,100);
            const over = c.spent > c.budget;
            return (
              <div key={i}>
                <div style={{ display:"flex", justifyContent:"space-between", marginBottom:5 }}>
                  <span style={{ fontSize:13, fontWeight:700, color:D.textMed }}>{c.label}</span>
                  <span style={{ fontSize:12.5, fontWeight:700, color: over ? D.red : D.textMut }}>₹{fmt(c.spent*1000)} {over && "⚠️"}</span>
                </div>
                <div style={{ height:6, borderRadius:999, background:D.white10, overflow:"hidden" }}>
                  <div className="anim-bar" style={{ height:"100%", width:pct+"%", borderRadius:999, background: over ? D.red : c.color, transition:"width .8s ease" }} />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

// ── Section label helper ─────────────────────────────────────────
function SectionLabel({ icon, text, count, sub, subColor }) {
  return (
    <div style={{ display:"flex", alignItems:"center", gap:8, padding:"4px 2px" }}>
      <span style={{ fontSize:15 }}>{icon}</span>
      <span style={{ fontSize:13, fontWeight:800, color:D.textMed, textTransform:"uppercase", letterSpacing:".05em" }}>{text}</span>
      {count != null && <span style={{ fontSize:12, fontWeight:800, color:D.textMut, background:D.white6, padding:"2px 8px", borderRadius:999, marginLeft:2 }}>{count}</span>}
      {sub && <span style={{ fontSize:12, fontWeight:700, color: subColor || D.textMut, marginLeft:"auto" }}>{sub}</span>}
    </div>
  );
}

// ── Bottom nav V2 ─────────────────────────────────────────────────
function V2Nav({ items, active, onChange }) {
  return (
    <div style={{ position:"absolute", bottom:0, left:0, right:0, zIndex:30, background:"linear-gradient(to bottom, transparent, "+D.bg+" 40%)", paddingTop:24 }}>
      <div style={{ background:D.surface, borderTop:"1px solid "+D.border, display:"flex", padding:"10px 8px 28px" }}>
        {items.map(it => {
          const on = active === it.id;
          return (
            <button key={it.id} onClick={() => onChange(it.id)} style={{ flex:1, display:"flex", flexDirection:"column", alignItems:"center", gap:5, background:"none", border:"none", cursor:"pointer", fontFamily:"inherit", padding:"4px 0", position:"relative" }}>
              {on && <span style={{ position:"absolute", top:-1, left:"50%", transform:"translateX(-50%)", width:24, height:3, borderRadius:999, background:D.teal }} />}
              <Icon name={it.icon} size={22} color={on ? D.teal : D.textMut} />
              <span style={{ fontSize:10, fontWeight: on?800:600, color: on ? D.teal : D.textMut }}>{it.label}</span>
              {it.badge > 0 && <span style={{ position:"absolute", top:2, right:"calc(50% - 14px)", minWidth:15, height:15, borderRadius:999, background:D.red, color:"#fff", fontSize:9, fontWeight:800, display:"flex", alignItems:"center", justifyContent:"center", border:"1.5px solid "+D.bg }}>{it.badge}</span>}
            </button>
          );
        })}
      </div>
    </div>
  );
}

// ── Main V2 leader home ───────────────────────────────────────────
function LeaderHomeV2({ onOpenAssistant, onSearch, onProfile, onNav, badge, flash }) {
  const [tab, setTab] = useState("Overview");

  return (
    <div style={{ position:"absolute", inset:0, background:D.bg, display:"flex", flexDirection:"column", overflow:"hidden" }}>
      {/* Status bar */}
      <V2StatusBar
        name="Vikram Mehta"
        initials="VM"
        badge={badge}
        onBell={onOpenAssistant}
        onProfile={onProfile}
      />

      {/* Scrollable content */}
      <div style={{ flex:1, minHeight:0, overflowY:"auto", overflowX:"hidden", paddingBottom:100, scrollbarWidth:"none" }}>
        <V2Hero name="Vikram" pending={23} />
        <V2KPIStrip />
        <V2Tabs active={tab} onChange={setTab} />

        <div style={{ padding:"18px 16px 0" }}>
          {tab === "Overview"  && <OverviewSection flash={flash} />}
          {tab === "Projects"  && <ProjectsSection flash={flash} />}
          {tab === "People"    && <PeopleSection   flash={flash} />}
          {tab === "Finance"   && <FinanceSection  flash={flash} />}
        </div>
      </div>

      {/* AI Fab — sits above nav */}
      <button
        onClick={onOpenAssistant}
        style={{
          position:"absolute", bottom:104, right:20, zIndex:20,
          width:48, height:48, borderRadius:999,
          background:"linear-gradient(135deg,"+D.teal+",#0097A7)",
          border:"none", cursor:"pointer", display:"flex", alignItems:"center", justifyContent:"center",
          boxShadow:"0 4px 24px rgba(0,196,176,.35)",
          animation:"sparkPulse 2.8s ease-in-out infinite",
        }}>
        <Icon name="ai_sparkle" size={22} color="#000" />
      </button>

      {/* V2 bottom nav */}
      <V2Nav
        items={[
          { id:"home",      icon:"home",             label:"Home"      },
          { id:"reports",   icon:"analytics",        label:"Analytics" },
          { id:"approvals", icon:"ai_sparkle",       label:"HR Buddy"  },
          { id:"more",      icon:"more_horizontal",  label:"Menu"      },
        ]}
        active="home"
        onChange={onNav}
      />
    </div>
  );
}
