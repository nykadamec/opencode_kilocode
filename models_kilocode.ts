/**
 * Models configuration for Kilocode provider
 * Fetches available models from OpenRouter API
 */

/** Model definition interface */
interface ModelInfo {
  name: string;
}

/** Available AI Models type */
type AvailableModels = Record<string, ModelInfo>;

/**
 * Fetches available models from OpenRouter API
 * @returns Promise with available models object
 */
export async function fetchAvailableModels(): Promise<AvailableModels> {
  try {
    const response = await fetch('https://openrouter.ai/api/v1/models', {
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'Kilo-Code/4.91.0'
      }
    });

    if (!response.ok) {
      throw new Error(`Failed to fetch models: ${response.status}`);
    }

    const data = await response.json();
    const models: AvailableModels = {};

    // Transform API response to our format
    if (data.data && Array.isArray(data.data)) {
      data.data.forEach((model: any) => {
        if (model.id && model.name) {
          models[model.id] = {
            name: model.name
          };
        }
      });
    }

    return models;
  } catch (error) {
    console.warn('Failed to fetch models from OpenRouter, using fallback:', error);
    return getFallbackModels();
  }
}

/**
 * Fallback models when API is not available
 */
function getFallbackModels(): AvailableModels {
  return {
   'openrouter/sonoma-dusk-alpha': { name: "Sonoma Dusk Alpha" },
    'openrouter/sonoma-sky-alpha': { name: "Sonoma Sky Alpha" },
    'qwen/qwen3-coder:free': { name: "Qwen: Qwen3 Coder 480B A35B (free)" },
    'qwen/qwen3-coder': { name: "Qwen: Qwen3 Coder 480B A35B" },
    'openai/gpt-oss-120b:free': { name: "OpenAI: gpt-oss-120b (free)" },
    'openai/gpt-oss-120b': { name: "OpenAI: gpt-oss-120b" },
    'openai/gpt-oss-20b:free': { name: "OpenAI: gpt-oss-20b (free)" },
    'openai/gpt-oss-20b': { name: "OpenAI: gpt-oss-20b" },
    'openai/gpt-5': { name: "OpenAI: GPT-5" },
    'openai/gpt-5-mini': { name: "OpenAI: GPT-5 Mini" },
    'openai/gpt-5-nano': { name: "OpenAI: GPT-5 Nano" },
    'x-ai/grok-4': { name: "xAI: Grok 4" },
    'x-ai/grok-code-fast-1': { name: "xAI: Grok Code Fast 1" },
    'google/gemini-2.5-flash': { name: "Google: Gemini 2.5 Flash" },
    'google/gemini-2.5-pro': { name: "Google: Gemini 2.5 Pro" },
    'anthropic/claude-opus-4': { name: "Anthropic: Claude Opus 4" },
    'anthropic/claude-sonnet-4': { name: "Anthropic: Claude Sonnet 4" },
    'openai/gpt-4.1': { name: "OpenAI: GPT-4.1" }

  };
}

/**
 * Gets available models (cached or fetched)
 */
let cachedModels: AvailableModels | null = null;

export async function getAvailableModels(): Promise<AvailableModels> {
  if (cachedModels) {
    return cachedModels;
  }

  cachedModels = await fetchAvailableModels();
  return cachedModels;
}

/**
 * Export fallback models for immediate use
 */
export const AVAILABLE_MODELS = getFallbackModels();

export type { AvailableModels, ModelInfo };