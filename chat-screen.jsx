/* global React, Icon */
const { useState: useChatState, useRef: useChatRef, useEffect: useChatEffect } = React;

// Persona-aware canned knowledge for the demo chatbot.
const CHAT_DATA = {
  leader: {
    greeting: "Morning, Vikram. I've gone through your organisation. Ask me anything — pipeline, people, approvals or budget.",
    prompts: ["What changed since yesterday?", "Who is blocked this week?", "Draft my review summary", "What can I safely delegate?"],
    answers: [
    [/changed|yesterday|since/, "Since yesterday:\n• On-time delivery rose to 86% (+4 pts)\n• Platform pipeline slipped 8% — I've drafted a fix\n• 1 urgent travel approval came in\n• 12 new CVs received"],
    [/block|stuck|risk/, "Two things are blocked:\n• The Payments rewrite is two sprints behind and short one engineer.\n• The Product Designer search has stalled at 71 days with no candidates."],
    [/draft|summary|review/, "Here's a 3-line summary for your 10am review:\n1. Delivery is healthy at 86% and trending up.\n2. Capacity is the watch-item at 113% — team is overloaded.\n3. One hiring escalation (Sr. Backend offer) needs your call today."],
    [/delegate|safely|auto/, "You can safely hand off:\n• 14 low-risk approvals (routine leave + expenses under ₹10,000) — I can clear these now.\n• First-round screening for the EM, Platform role to your team lead."],
    [/budget|spend|expense/, "Q2 spend is ₹86L of ₹1.04 Cr — 4% over pace. Team travel is the main driver at ₹35L (+8% vs plan)."]],

    fallback: "I've checked across pipeline, people, approvals and budget. The headline today: delivery is healthy, capacity is stretched at 113%, and one hiring offer needs your decision. Want me to go deeper on any of these?"
  },
  employee: {
    greeting: "Morning, Priya. Ask me about your tasks, leave, pay or goals — I'll pull it together for you.",
    prompts: ["What's due today?", "How much leave do I have left?", "When is my next payslip?", "Help me apply for leave"],
    answers: [
    [/due|today|task/, "Due today:\n• “Checkout redesign” review at 11:00 (high priority)\n• Last day to apply for June leave\n• H2 goals & objectives filing just opened"],
    [/leave|holiday|off/, "Your leave balance:\n• Casual 6 / 12\n• Earned 14 / 18\n• Sick 5 / 8\nWant me to start a leave request?"],
    [/pay|salary|payslip|credit/, "Your May payslip (net ₹1,42,380) is ready. June pay credits on 30 Jun. You also have a ₹3,200 reimbursement pending."],
    [/goal|objective|h2/, "H2 goal filing is open until 15 Jun. You have 0 of 3 goals set so far. Want me to draft starter goals from your last cycle?"]],

    fallback: "I've looked across your tasks, leave, pay and goals. The main things today: your design review at 11, the leave-apply deadline, and goal filing now open. What would you like to do?"
  }
};

function ChatScreen({ persona, seed, onClose }) {
  const data = CHAT_DATA[persona] || CHAT_DATA.leader;
  const [msgs, setMsgs] = useChatState([{ from: "ai", text: data.greeting }]);
  const [input, setInput] = useChatState("");
  const [typing, setTyping] = useChatState(false);
  const scrollRef = useChatRef(null);

  useChatEffect(() => {
    if (scrollRef.current) scrollRef.current.scrollTop = scrollRef.current.scrollHeight;
  }, [msgs, typing]);

  const answerFor = (q) => {
    const t = q.toLowerCase();
    for (const [re, a] of data.answers) {if (re.test(t)) return a;}
    return data.fallback;
  };

  const send = (text) => {
    const q = (text || "").trim();
    if (!q) return;
    setInput("");
    setMsgs((m) => [...m, { from: "me", text: q }]);
    setTyping(true);
    clearTimeout(window.__chatT);
    window.__chatT = setTimeout(() => {
      setTyping(false);
      setMsgs((m) => [...m, { from: "ai", text: answerFor(q) }]);
    }, 850);
  };

  // Auto-send the prompt the user picked in the bottom sheet.
  useChatEffect(() => {
    if (seed) send(seed);
    // eslint-disable-next-line
  }, []);

  const showPrompts = msgs.length <= 1 && !typing && !seed;

  return (
    <div style={{ position: "absolute", inset: 0, zIndex: 50, display: "flex", flexDirection: "column", background: "var(--surface-subtle)", animation: "fadeIn .2s ease" }}>
      {/* header */}
      <div style={{ height: 56, padding: "0 8px 0 6px", display: "flex", alignItems: "center", gap: 8, background: "var(--surface-minimal)", borderBottom: "1px solid var(--stroke-minimal)", flexShrink: 0 }}>
        <button onClick={onClose} aria-label="Close" style={{ width: 40, height: 40, borderRadius: 999, border: "none", background: "none", cursor: "pointer", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Icon name="arrow_back" size={22} color="var(--content-heavy)" />
        </button>
        <span style={{ width: 30, height: 30, borderRadius: 9, background: "var(--sky)", display: "flex", alignItems: "center", justifyContent: "center" }}>
          <Icon name="ai_sparkle" size={18} color="#fff" />
        </span>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div style={{ fontSize: 15, fontWeight: 800, color: "var(--content-heavy)", letterSpacing: "-.01em" }}>PeopleFirst AI</div>
          <div style={{ fontSize: 11.5, color: "var(--positive)", fontWeight: 600, display: "flex", alignItems: "center", gap: 5 }}>
            <span style={{ width: 6, height: 6, borderRadius: 999, background: "var(--positive)" }} />Online
          </div>
        </div>
      </div>

      {/* messages */}
      <div ref={scrollRef} style={{ flex: 1, overflow: "auto", padding: "16px 16px 8px", display: "flex", flexDirection: "column", gap: 10 }}>
        {msgs.map((m, i) =>
        <div key={i} style={{ display: "flex", justifyContent: m.from === "me" ? "flex-end" : "flex-start" }}>
            <div style={{
            maxWidth: "82%", padding: "11px 14px", borderRadius: 18, fontSize: 13.5, lineHeight: 1.45, whiteSpace: "pre-line", textWrap: "pretty",
            background: m.from === "me" ? "var(--reliance-base)" : "var(--surface-minimal)",
            color: m.from === "me" ? "#fff" : "var(--content-heavy)",
            border: m.from === "me" ? "none" : "1px solid var(--stroke-minimal)",
            borderBottomRightRadius: m.from === "me" ? 5 : 18,
            borderBottomLeftRadius: m.from === "me" ? 18 : 5,
            fontWeight: m.from === "me" ? 600 : 500
          }}>{m.text}</div>
          </div>
        )}
        {typing &&
        <div style={{ display: "flex", justifyContent: "flex-start" }}>
            <div style={{ padding: "13px 16px", borderRadius: 18, borderBottomLeftRadius: 5, background: "var(--surface-minimal)", border: "1px solid var(--stroke-minimal)", display: "flex", gap: 4 }}>
              {[0, 1, 2].map((d) =>
            <span key={d} style={{ width: 7, height: 7, borderRadius: 999, background: "var(--content-minimal)", animation: `chatDot 1s ${d * .15}s infinite ease-in-out` }} />
            )}
            </div>
          </div>
        }
      </div>

      {/* suggested prompts */}
      {showPrompts &&
      <div style={{ padding: "0 16px 10px", display: "flex", flexDirection: "column", gap: 8 }}>
          {data.prompts.map((p) =>
        <button key={p} onClick={() => send(p)} style={{ textAlign: "left", padding: "11px 14px", borderRadius: 13, border: "1px solid var(--sky-border)", background: "var(--sky-light)", cursor: "pointer", fontFamily: "inherit", fontSize: 13.5, fontWeight: 600, color: "var(--sky-ink)", display: "flex", alignItems: "center", gap: 9 }}>
              <Icon name="ai_sparkle" size={15} color="var(--sky)" />{p}
            </button>
        )}
        </div>
      }

      {/* input */}
      <div style={{ padding: "10px 14px calc(10px + env(safe-area-inset-bottom, 0px))", background: "var(--surface-minimal)", borderTop: "1px solid var(--stroke-minimal)", flexShrink: 0 }}>
        <div style={{ display: "flex", alignItems: "center", gap: 8, padding: "0 6px 0 16px", minHeight: 48, borderRadius: 999, border: "1px solid var(--stroke-heavy)" }}>
          <input
            value={input}
            onChange={(e) => setInput(e.target.value)}
            onKeyDown={(e) => {if (e.key === "Enter") send(input);}}
            placeholder="Ask anything…"
            style={{ flex: 1, border: "none", outline: "none", background: "transparent", fontFamily: "inherit", fontSize: 14, color: "var(--content-heavy)", padding: "10px 0" }} />

          <button onClick={() => send(input)} aria-label="Send" style={{ width: 38, height: 38, borderRadius: 999, border: "none", background: input.trim() ? "var(--sky)" : "var(--surface-subtle)", display: "flex", alignItems: "center", justifyContent: "center", cursor: "pointer", flexShrink: 0, transition: "background .2s" }}>
            <Icon name="send_message" size={18} color={input.trim() ? "#fff" : "var(--content-minimal)"} />
          </button>
        </div>
      </div>
    </div>);

}

Object.assign(window, { ChatScreen });
