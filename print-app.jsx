/* global React, ReactDOM, Icon, Button, Card, Signal, Dot, Widget,
   AIBriefing, Performance, ExpenseBudget, ExpenseBudgetBars, ActionItems, TeamSnapshot, Recruitment, Bookings, News,
   EmpBrief, Attendance, QuickLinks, BookingsEmp, Tasks, EmpNews, RefersCard */

const noop = () => {};

// Seed data mirrored from the live app
const DECISIONS = [
  { id: "d1", tone: "off", title: "High-Impact Retention Decision", detail: "Rajeev Sharma, part of the PeopleFirst team under Sanjiv Tuli, has received an external offer. HR has recommended an off-cycle salary increment of ₹5 lakh, which is within the approved range.", cta: { label: "Review", variant: "sky" }, secondary: "Dashboard" },
  { id: "d2", tone: "risk", title: "OFFICE365 renewal expires in 7 days", detail: "Annual cost of ₹14L approved by Finance and Legal. Awaiting your final approval.", cta: { label: "Renew", variant: "sky" }, secondary: "Review contract" }];

const APPROVE = { total: 23, lowRisk: 14, approved: 0 };

const EMP_TASKS = [
  { id: 1, title: "Review “Checkout redesign” PR", source: "Azure", priority: "high", due: "Today", done: false },
  { id: 2, title: "Ship empty-states for Tasks widget", source: "Azure", priority: "high", due: "Today", done: false },
  { id: 3, title: "Prep handoff notes for dev", source: "Self", priority: "med", due: "Today", done: false },
  { id: 4, title: "Update design tokens doc", source: "Azure", priority: "med", due: "Tomorrow", done: false },
  { id: 5, title: "Book usability sessions", source: "Self", priority: "low", due: "Fri", done: false }];

const ATT = (() => { const d = (h, m) => { const x = new Date(); x.setHours(h, m, 0, 0); return x.getTime(); }; return { status: "done", inAt: d(9, 30), outAt: d(17, 45) }; })();

const EMP_ITEMS = [
  { id: "t", icon: "list", bg: "var(--negative-light)", fg: "var(--negative)", title: "“Checkout redesign” review due 11:00", detail: "2 hours away · High priority", target: "tasks" },
  { id: "l", icon: "calendar", bg: "var(--warning-light)", fg: "var(--warning)", title: "Today is your last day to apply for leave", detail: "June planned leave closes at 6pm", target: "leave" },
  { id: "g", icon: "star", bg: "var(--sky-light)", fg: "var(--sky)", title: "Goals & objectives filing has started", detail: "Set your H2 goals · due 15 Jun", target: "profile" }];

// Static header (mirrors the in-app Header, non-interactive)
function PrintHeader({ name, initials }) {
  return (
    <div style={{ padding: "10px 16px 4px", background: "var(--surface-minimal)" }}>
      <div style={{ display: "flex", alignItems: "center", gap: 4 }}>
        <div style={{ flex: 1, minWidth: 0 }}>
          <h1 style={{ margin: 0, fontSize: 22, fontWeight: 900, letterSpacing: "-.025em", color: "var(--content-heavy)", lineHeight: 1.1 }}>Good morning</h1>
          <div style={{ fontSize: 13.5, fontWeight: 600, color: "var(--content-moderate)", marginTop: 2 }}>{name}</div>
        </div>
        <span style={{ width: 40, height: 40, borderRadius: 999, display: "flex", alignItems: "center", justifyContent: "center" }}><Icon name="search" size={22} color="var(--content-heavy)" /></span>
        <span style={{ width: 40, height: 40, borderRadius: 999, display: "flex", alignItems: "center", justifyContent: "center" }}><Icon name="notification" size={22} color="var(--content-heavy)" /></span>
        <span style={{ width: 42, height: 42, borderRadius: 999, background: "var(--reliance-base)", color: "#fff", display: "flex", alignItems: "center", justifyContent: "center", fontSize: 16, fontWeight: 800, marginLeft: 4 }}>{initials}</span>
      </div>
    </div>
  );
}

// Static bottom nav strip (visual fidelity)
function PrintNav({ items }) {
  return (
    <div style={{ background: "var(--surface-minimal)", borderTop: "1px solid var(--stroke-minimal)", display: "flex", padding: "8px 4px 14px", marginTop: 6 }}>
      {items.map((it, i) => (
        <div key={it.label} style={{ flex: 1, display: "flex", flexDirection: "column", alignItems: "center", gap: 4, color: i === 0 ? "var(--reliance-base)" : "var(--content-minimal)" }}>
          <Icon name={it.icon} size={22} color={i === 0 ? "var(--reliance-base)" : "var(--content-minimal)"} />
          <span style={{ fontSize: 10.5, fontWeight: i === 0 ? 700 : 600 }}>{it.label}</span>
        </div>
      ))}
    </div>
  );
}

const SKY = { "--sky": "oklch(62% 0.145 236)", "--sky-ink": "oklch(36% 0.105 236)", "--sky-light": "oklch(95.5% 0.032 236)", "--sky-border": "oklch(88% 0.052 236)", "--sky-shadow": "oklch(62% 0.145 236 / 0.45)" };

function Page({ label, children }) {
  return (
    <div className="page">
      <div className="page-cap">{label}</div>
      <div className="device" style={{ ...SKY }}>
        {children}
      </div>
    </div>
  );
}

function LeaderHome() {
  return (
    <React.Fragment>
      <PrintHeader name="Vikram" initials="VM" />
      <div style={{ padding: "16px 16px 20px", display: "flex", flexDirection: "column", gap: 14, background: "var(--surface-subtle)" }}>
        <AIBriefing expanded={true} onToggle={noop} decisions={DECISIONS} onResolve={noop} onOpenAssistant={noop} />
        <Performance onOpen={noop} />
        <ExpenseBudget onOpen={noop} />
        <ExpenseBudgetBars onOpen={noop} />
        <ActionItems state={APPROVE} onBulkApprove={noop} onOpen={noop} />
        <TeamSnapshot onOpen={noop} />
        <Recruitment onOpen={noop} />
        <Bookings onOpen={noop} />
        <News onOpen={noop} onWish={noop} />
      </div>
      <PrintNav items={[{ icon: "home", label: "Home" }, { icon: "group", label: "Team" }, { icon: "confirm", label: "Approvals" }, { icon: "analytics", label: "Reports" }, { icon: "more_horizontal", label: "More" }]} />
    </React.Fragment>
  );
}

function EmployeeHome() {
  return (
    <React.Fragment>
      <PrintHeader name="Priya" initials="PS" />
      <div style={{ padding: "16px 16px 20px", display: "flex", flexDirection: "column", gap: 14, background: "var(--surface-subtle)", textAlign: "left" }}>
        <EmpBrief items={EMP_ITEMS} onItem={noop} onOpenAssistant={noop} />
        <Attendance att={ATT} onMark={noop} onOpen={noop} />
        <QuickLinks onGo={noop} />
        <Tasks tasks={EMP_TASKS} onToggle={noop} onNew={noop} onOpen={noop} />
        <BookingsEmp onViewAll={noop} />
        <EmpNews onOpen={noop} />
        <RefersCard onCall={noop} />
      </div>
      <PrintNav items={[{ icon: "home", label: "Home" }, { icon: "list", label: "Tasks" }, { icon: "time", label: "Attendance" }, { icon: "rupee", label: "Pay" }, { icon: "more_horizontal", label: "More" }]} />
    </React.Fragment>
  );
}

function PrintApp() {
  return (
    <React.Fragment>
      <Page label="PeopleFirst · Leader home — Vikram Menon">
        <LeaderHome />
      </Page>
      <Page label="PeopleFirst · Employee home — Priya Sharma">
        <EmployeeHome />
      </Page>
    </React.Fragment>
  );
}

ReactDOM.createRoot(document.getElementById("root")).render(<PrintApp />);

// Auto-print once fonts + JSX are ready
(function () {
  function go() { setTimeout(() => window.print(), 600); }
  if (document.fonts && document.fonts.ready) {
    document.fonts.ready.then(() => setTimeout(go, 400));
  } else {
    window.addEventListener("load", () => setTimeout(go, 700));
  }
})();
