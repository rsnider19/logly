# Feature Landscape

**Domain:** AI Chat Assistant for Personal Activity Data (Text-to-SQL)
**Project:** Logly AI Insights
**Researched:** 2026-02-02
**Overall Confidence:** HIGH

## Context

Logly already has significant backend infrastructure for AI chat:
- Supabase edge function (`ai-insights`) with a 4-stage pipeline: NL-to-SQL conversion, SQL validation, SQL execution, streaming response generation
- Fine-tuned GPT-4.1-mini model for NL-to-SQL conversion with training data (8+ JSONL files)
- Server-Sent Events (SSE) streaming with step progress indicators
- SQL security validation (regex-based, read-only enforcement, dangerous keyword blocking)
- Database tables for insight logging (`user_ai_insight`, `user_ai_insight_step`), suggested prompts (`ai_insight_suggested_prompt`), and cost reporting
- Multi-turn conversation support via OpenAI `previous_response_id` chaining
- Entitlement gating via RevenueCat (`ai-insights` entitlement)
- Chat UI packages already in pubspec: `flutter_chat_core`, `flutter_chat_ui`, `flyer_chat_text_stream_message`, `gpt_markdown`
- Flutter feature directory scaffolded but empty (`lib/features/ai_insights/`)

The client-side Flutter implementation is what needs to be built. This research focuses on what features the chat experience should have.

---

## Table Stakes

Features users expect from an AI chat interface in a data app. Missing any of these will make the feature feel broken or amateurish.

| Feature | Why Expected | Complexity | Existing Infrastructure |
|---------|--------------|------------|------------------------|
| **Natural language input** | Core promise of the feature. Users type questions in plain English and get data-backed answers. | Low | Edge function handles NL-to-SQL conversion |
| **Streaming response display** | Users expect to see text appear progressively, not wait 5-10s for a complete response. Every major AI chat product streams. Sub-2s time-to-first-token is the benchmark. | Medium | SSE streaming with text deltas already implemented server-side; `flyer_chat_text_stream_message` package in pubspec |
| **Pipeline progress indicators** | During the 3-8 second processing time, users need visual feedback. Silence beyond 2 seconds feels broken. Show step-by-step progress (thinking, fetching, generating). | Medium | Server sends `step` messages with status (in_progress, complete, error); client needs to render these |
| **Suggested starter questions** | Empty chat screens cause blank-page paralysis. Starters teach users what the bot can do and reduce first-interaction friction. Industry standard across ChatGPT, WHOOP Coach, and every AI assistant. | Low | `ai_insight_suggested_prompt` table already exists with 3 seed prompts |
| **Multi-turn conversations** | Users expect follow-up questions to work: "How many runs this week?" then "What about last week?" Without this, every question is isolated and the experience feels robotic. | Medium | OpenAI `previous_response_id` chaining implemented server-side; client needs to pass IDs |
| **Markdown-formatted responses** | AI responses with bold numbers, lists, and structured formatting are table stakes since ChatGPT. Plain text responses feel dated. | Low | `gpt_markdown` package in pubspec; server response agent already outputs markdown |
| **Graceful error handling** | When the AI cannot answer (bad SQL, empty data, API failure), users need clear, friendly messaging with suggested recovery actions -- not crashes or generic errors. | Medium | Server sends typed error messages with user-friendly text; client needs error state UI |
| **Pro subscription gating** | Feature must be locked behind pro subscription with clear upgrade prompts. Users expect paywall UX to be seamless. | Low | RevenueCat `ai-insights` entitlement check exists server-side; client needs gate UI |
| **Message input UX** | Text input with send button, keyboard handling, auto-scroll to latest message, disabled input during streaming. Standard chat mechanics. | Medium | `flutter_chat_ui` package handles core input mechanics |
| **Empty data acknowledgment** | When user has no data for a query ("How far did I run?" but they never logged running), the response must be encouraging, not confusing. Suggest logging the activity. | Low | Server response agent instructed to handle empty results gracefully |

---

## Differentiators

Features that set Logly apart from generic AI chat. Not expected, but create competitive advantage and delight.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| **Contextual suggested follow-ups** | After each response, show 2-3 follow-up question chips based on the data just returned. "You ran 15 miles last week" could suggest "Compare to the week before" or "Show my monthly trend." Reduces typing and deepens engagement. | Medium | Requires server-side follow-up generation or client-side templates based on query type |
| **Conversation history persistence** | Save past conversations, browse them, continue where you left off. WHOOP Coach and ChatGPT both offer this. Transforms chat from single-use to an ongoing relationship with your data. | High | Requires new `conversation` and `message` tables in Supabase, list UI, conversation selection, and message hydration. Current `user_ai_insight` table logs individual queries but does not model conversations. |
| **Data-aware starter personalization** | Instead of generic starters, show questions relevant to the user's actual data: "You logged 12 yoga sessions this month -- ask about your streak!" Converts passive starters into engagement hooks. | High | Requires server-side query to analyze user's recent activity and generate personalized prompts |
| **Encouraging tone with personal records** | When query results reveal personal bests or milestones, celebrate them: "That is your longest run ever!" Transforms cold data analysis into a coaching moment. | Medium | Requires enriching the response agent's context with historical bests, or a post-processing step |
| **Activity-context deep links** | When the AI mentions a specific activity or date, make it tappable to navigate to that activity's detail screen. Bridges the gap between chat and the rest of the app. | High | Requires structured data in responses (not just markdown text), entity extraction, and deep link routing |
| **Haptic and animation feedback** | Subtle haptic feedback when a response starts streaming, animations on milestone celebrations, smooth transitions on step progress. These polish details separate premium from passable. | Low | Pure client-side implementation using Flutter animation APIs |
| **Conversation search** | Search across past conversations to find that insight from weeks ago. Power-user feature that increases perceived value of chat history. | Medium | Requires full-text search on conversation messages, likely via Supabase `tsvector` |
| **Query confidence indicator** | Subtle indicator when the AI is less confident about its interpretation. Helps users rephrase rather than trust incorrect results. Medium transparency research shows this is the sweet spot for user trust. | Medium | Could derive from SQL validation step or a confidence score from the NL-to-SQL model |

---

## Anti-Features

Features to explicitly NOT build. Common mistakes in this domain that would waste time, add complexity, or hurt the experience.

| Anti-Feature | Why Avoid | What to Do Instead |
|--------------|-----------|-------------------|
| **Showing raw SQL to users** | Research shows medium transparency is optimal. Showing full SQL overwhelms non-technical users (100% of Logly's audience). Academic studies found high-transparency groups had declining accuracy and engagement over time. Only developers would appreciate seeing SQL. | Use the existing step progress indicators ("Reading through your Logly", "Grabbing the relevant entries") to communicate what is happening without technical details. If transparency is later desired, make it an opt-in developer/debug mode. |
| **Voice input** | Adds platform-specific complexity (speech-to-text APIs, microphone permissions, noise handling) for marginal benefit. Text input is sufficient for data queries. PROJECT.md explicitly lists this as out of scope for v1. | Focus on reducing typing friction with suggested starters, follow-up chips, and good keyboard UX instead. |
| **Image/chart generation in responses** | Generating charts requires a rendering pipeline, chart type selection logic, and significant additional LLM context. Text-based analysis with bold numbers and markdown formatting is sufficient and much simpler. PROJECT.md lists this as out of scope. | Use markdown with bold numbers and structured lists. If users want charts, they already exist on the Profile/Statistics screens -- consider linking to them. |
| **AI-initiated proactive notifications** | Push notifications with AI insights require a background job system, notification fatigue management, and careful privacy considerations. PROJECT.md explicitly defers this to post-chat. Building reactive chat first validates whether users want AI insights at all. | Build the reactive chat experience first. Monitor usage patterns to determine if proactive insights have demand before investing. |
| **Chat export/sharing** | No clear user need. Sharing personal activity data externally has privacy implications and minimal engagement benefit. PROJECT.md lists this as out of scope. | If sharing is ever needed, screenshots of the chat screen serve the purpose without engineering investment. |
| **General-purpose chatbot capabilities** | The LLM should ONLY answer questions about the user's logged data. Allowing general conversation (recipes, trivia, coding help) dilutes the value proposition, increases API costs, and creates moderation headaches. | Set strict system prompt boundaries. When users ask off-topic questions, respond with a friendly redirect: "I am best at answering questions about your Logly data! Try asking about your activities." |
| **Real-time streaming with WebSockets** | WebSocket-based streaming adds connection management complexity. SSE is simpler, well-suited for one-way streaming (server-to-client), and already implemented. | Continue using SSE. The existing implementation works well for this use case. |
| **Offline chat** | Text-to-SQL requires server-side LLM calls and database queries. Offline chat would require local LLM inference (not feasible on mobile) or response caching (limited utility). | Show a clear offline state: "Chat requires an internet connection. Your previous conversations are available once you are back online." If history is persisted server-side, it becomes available on reconnection. |
| **Edit/regenerate previous messages** | ChatGPT-style message editing adds substantial UI complexity (branching conversation trees, re-rendering history, state management). For a data query tool, simply asking a new question achieves the same result. | Allow users to tap a previous question to re-ask it (copy to input), which is much simpler than full edit/regenerate. |

---

## Feature Dependencies

```
Suggested Starters (standalone, no deps)
    |
    v
Natural Language Input --> Streaming Response Display --> Markdown Formatting
    |                           |
    |                           v
    |                    Pipeline Progress Indicators
    |                           |
    v                           v
Multi-turn Conversations --> Graceful Error Handling
    |
    v
Conversation History Persistence --> Conversation Search
    |
    v
Contextual Follow-up Suggestions (requires multi-turn + response analysis)
    |
    v
Data-aware Starter Personalization (requires history + user data analysis)
    |
    v
Activity-context Deep Links (requires structured response data + routing)
```

**Key dependency insights:**
1. Streaming response display is the foundation -- everything else depends on being able to show AI responses.
2. Multi-turn conversations must work before conversation history makes sense (otherwise you are just saving isolated Q&A pairs).
3. Follow-up suggestions require multi-turn to be useful (tapping a suggestion should continue the conversation, not start a new one).
4. Deep links are the most dependent feature -- requiring structured response parsing, entity extraction, and integration with the existing router.

---

## MVP Recommendation

**For MVP, prioritize all table stakes features:**

1. **Chat screen with text input** -- The container for everything else
2. **Streaming response display with markdown** -- Core value delivery
3. **Pipeline progress indicators** -- Prevents "is it broken?" during processing
4. **Suggested starter questions** -- Solves the cold start problem
5. **Multi-turn conversations** -- Already supported server-side, client just passes IDs
6. **Graceful error handling** -- Prevents frustration on the 20% of queries that may fail
7. **Pro subscription gate** -- Revenue protection
8. **Empty data acknowledgment** -- Already handled server-side

**First differentiator to add (low effort, high impact):**
- **Contextual follow-up suggestions** -- Significantly increases engagement per session and reduces typing friction

**Defer to post-MVP:**
- **Conversation history persistence**: High complexity (new tables, list UI, message hydration). The existing `user_ai_insight` table already logs queries for debugging. True conversation history is valuable but not MVP-blocking.
- **Data-aware starter personalization**: Requires server-side user data analysis. Generic starters work fine initially.
- **Activity-context deep links**: High complexity with entity extraction. Can be layered on later without breaking existing chat.
- **Conversation search**: Only valuable after conversation history exists.
- **Query confidence indicators**: Nice-to-have after initial launch validates the approach.

---

## Complexity Estimates

| Feature | Client Effort | Server Effort | Total |
|---------|--------------|---------------|-------|
| Chat screen + input | Medium | None (exists) | Medium |
| Streaming display | Medium | None (exists) | Medium |
| Progress indicators | Low-Medium | None (exists) | Low-Medium |
| Suggested starters | Low | None (exists) | Low |
| Multi-turn | Low | None (exists) | Low |
| Error handling | Medium | None (exists) | Medium |
| Pro gate | Low | None (exists) | Low |
| Markdown formatting | Low | None (exists) | Low |
| Follow-up suggestions | Medium | Low-Medium | Medium |
| Conversation history | High | Medium | High |
| Personalized starters | Medium | High | High |
| Deep links | High | Medium | High |

**Key insight:** The server-side pipeline is already built and robust. The entire MVP is a client-side implementation challenge. This significantly reduces risk and total effort.

---

## Competitive Landscape

| Competitor | AI Chat Feature | Key Differentiator | Relevance to Logly |
|------------|----------------|-------------------|---------------------|
| **WHOOP Coach** | Conversational health AI built on OpenAI, analyzes biometric data (strain, sleep, HRV) | Deep wearable data integration, recovery-focused coaching | Most directly comparable. Logly's advantage: broader activity types beyond fitness biometrics. |
| **ChatGPT Health** | Dedicated health feature with Apple Health integration, isolated data compartment | 260+ physician input, medical record integration, strict data isolation | Sets the bar for data privacy in health AI. Logly should follow its data isolation patterns. |
| **Apple Health+** | Upcoming AI-powered health coach (2026) | Native OS integration, comprehensive health data access | Will be the elephant in the room. Logly's advantage: activity-specific depth and custom activity support. |
| **SensAI** | AI personal trainer using Oura/WHOOP HRV data | Recovery-aware workout modification | Focused on workout prescription, not general data queries. Different use case. |
| **Strava** | Performance analytics (no conversational AI yet) | Community-driven, GPS-focused | No AI chat competitor yet, but strong data analytics. Logly beats them on conversational interface. |

---

## Sources

- [Salesforce Text-to-SQL Agent](https://www.salesforce.com/blog/text-to-sql-agent/) -- Real-world text-to-SQL deployment learnings (transparency, accuracy iteration)
- [Understanding Algorithm Transparency in Text-to-SQL](https://arxiv.org/html/2410.16283) -- Academic research on optimal transparency levels
- [Reducing Hallucinations in Text-to-SQL](https://www.getwren.ai/post/reducing-hallucinations-in-text-to-sql-building-trust-and-accuracy-in-data-access) -- Validation and semantic layer strategies
- [Feed.fm 2026 Digital Fitness Ecosystem Report](https://www.feed.fm/2026-digital-fitness-ecosystem-report) -- AI as table stakes in fitness apps
- [AI in Fitness 2026](https://orangesoft.co/blog/ai-in-fitness-industry) -- Market trends and feature expectations
- [NN/g Prompt Controls in GenAI Chatbots](https://www.nngroup.com/articles/prompt-controls-genai/) -- UX research on reducing typing burden
- [Smashing Magazine AI Interface Design Patterns](https://www.smashingmagazine.com/2025/07/design-patterns-ai-interfaces/) -- Modern AI UI patterns
- [TELUS Digital Conversational AI UX Best Practices](https://www.telusdigital.com/insights/digital-experience/article/7-ux-ui-rules-for-designing-a-conversational-ai-assistant) -- 7 core UX rules
- [Google PAIR Errors + Graceful Failure](https://pair.withgoogle.com/chapter/errors-failing/) -- Designing AI systems for failure
- [Cloudscape GenAI Loading States](https://cloudscape.design/patterns/genai/genai-loading-states/) -- Loading indicator patterns for AI
- [UX Tigers AI Response Time](https://www.uxtigers.com/post/ai-response-time) -- Time-to-first-token benchmarks
- [Apple Health+ AI Coach](https://apple.gadgethacks.com/news/apple-health-ai-coach-launches-2026-revolutionary-features/) -- Upcoming competitive feature (LOW confidence)
- [OpenAI ChatGPT Health Launch](https://macdailynews.com/2026/01/07/openai-launches-chatgpt-health-featuring-apple-health-integration/) -- Health data privacy patterns
- [Botpress Chatbot Best Practices](https://botpress.com/blog/chatbot-best-practices) -- Practical chatbot design guidance

---

*Feature landscape research: 2026-02-02*
