import { ModelResponse, RunItem, StreamedRunResult } from "npm:@openai/agents-core@0.3.5";

export function createAgentStreamHandler() {
  const textEncoder = new TextEncoder();

  type AgentSummary = {
    original_input: string;
    total_usage: {
      requests: number;
      inputTokens: number;
      outputTokens: number;
      totalTokens: number;
    };
    model_responses: { responses: ModelResponse[] };
    generated_items: { items: RunItem[] };
  };

  return {
    async streamTo(
      controller: ReadableStreamDefaultController,
      iterator: AsyncIterable<any>,
      onComplete: ((summary: AgentSummary) => void) | null = null,
    ) {
      try {
        for await (const event of iterator) {
          if (event.type === "raw_model_stream_event") {
            const data = event.data.event;
            if (data?.type === "response.output_text.delta") {
              controller.enqueue(textEncoder.encode(data.delta));
            }
          }
        }

        const result = (iterator as StreamedRunResult<any, any>);
        await result.completed
        
        if (onComplete) {
          const usage = result.state.usage;
          onComplete({
            original_input: JSON.stringify(result.state._originalInput),
            total_usage: {
              requests: usage.requests,
              inputTokens: usage.inputTokens,
              outputTokens: usage.outputTokens,
              totalTokens: usage.totalTokens,
            },
            model_responses: { responses: result.state._modelResponses },
            generated_items: { items: result.state._generatedItems },
          });
        }
      } catch (err) {
        console.error("Error in stream:", err);
        controller.error(err);
      } finally {
        controller.close();
      }
    },
  };
}
