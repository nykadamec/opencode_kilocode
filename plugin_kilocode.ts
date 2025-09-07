/**
 * KiloCode Provider Plugin for OpenCode
 * Adds KiloCode as an AI provider with support for multiple models
 */

// @ts-ignore
import type { Plugin, PluginInput } from "@opencode-ai/plugin";
import { AVAILABLE_MODELS, getAvailableModels } from './models_kilocode';

// Node.js process type declaration
declare const process: {
  env: Record<string, string | undefined>;
  exit: (code?: number) => never;
};

// === CONFIGURATION ===

/** API Configuration */
const API_CONFIG = {
  SCHEMA: 'https://opencode.ai/config.json',
  BASE_URL: 'https://kilocode.ai/api/openrouter',
  NPM_PACKAGE: '@ai-sdk/openai-compatible'
} as const;

/** Provider Information */
const PROVIDER_INFO = {
  NAME: 'kilocode.ai',
  DISPLAY_NAME: 'Kilocode.ai Unofficial',
  VERSION: '4.91.0',
  USER_AGENT: 'Kilo-Code/4.91.0',
  REFERER: 'https://kilocode.ai'
} as const;



// === HELPER FUNCTIONS ===

/**
 * Gets API key from environment variables
 */
function getApiKey(): string {
  // @ts-ignore
  return process.env.KILOCODE_API_KEY || '{env:KILOCODE_API_KEY}';
}

/**
 * Validates that API key is properly set
 */
function validateApiKey(): void {
  // @ts-ignore
  const apiKey = process.env.KILOCODE_API_KEY;
  
  if (!apiKey || apiKey === '{env:KILOCODE_API_KEY}') {
        console.error('\n❌ KILOCODE_API_KEY is not set!');
        console.error('Please set the KILOCODE_API_KEY environment variable.');
    console.error('\nOpenCode startup aborted.\n');

    console.log('You can get your API_KEY from https://app.kilocode.ai/profile');
    process.exit(1);
  }
}

/**
 * Creates HTTP headers for KiloCode API
 */
function createHeaders(apiKey: string): Record<string, string> {
  return {
    'Content-Type': 'application/json',
    'Authorization': `Bearer ${apiKey}`,
    'X-KiloCode-Version': PROVIDER_INFO.VERSION,
    'User-Agent': PROVIDER_INFO.USER_AGENT,
    'HTTP-Referer': PROVIDER_INFO.REFERER,
    'X-Title': 'Kilo Code'
  };
}

/**
 * Creates complete KiloCode provider configuration
 */
function createKiloCodeProviderConfig() {
  const apiKey = getApiKey();
  
  return {
    schema: API_CONFIG.SCHEMA,
    npm: API_CONFIG.NPM_PACKAGE,
    name: PROVIDER_INFO.DISPLAY_NAME,
    options: {
      baseURL: API_CONFIG.BASE_URL,
      apiKey,
      headers: createHeaders(apiKey)
    },
    models: AVAILABLE_MODELS
  };
}
/**
 * Checks and logs API key status
 */
function logApiKeyStatus(): void {
  // @ts-ignore
  const apiKey = process.env.KILOCODE_API_KEY;
  const status = apiKey && apiKey !== '{env:KILOCODE_API_KEY}' ? '✅ set' : '❌ not set';
  console.log(`🔧 API key status: ${status}`);
}

/**
 * Configures KiloCode provider in OpenCode configuration
 */
async function configureKiloCodeProvider(config: any): Promise<void> {
  // Validate API key before proceeding
  validateApiKey();
  
  // Initialize provider object if it doesn't exist
  if (!config.provider) {
    config.provider = {};
  }

  // Add KiloCode provider only if not already configured
  if (!config.provider[PROVIDER_INFO.NAME]) {
    logApiKeyStatus();
    
    config.provider[PROVIDER_INFO.NAME] = createKiloCodeProviderConfig();
    console.log(`✅ ${PROVIDER_INFO.DISPLAY_NAME} provider successfully configured`);
  }
}

// === PLUGIN IMPLEMENTATION ===

/** Flag to prevent duplicate initialization logs */
let isInitialized = false;

/**
 * Main KiloCode Provider Plugin for OpenCode
 */
export const KiloCodeProviderPlugin: Plugin = async (input: PluginInput) => {
  // Show initialization message only once
  if (!isInitialized) {
    console.log(`🚀 ${PROVIDER_INFO.DISPLAY_NAME} Plugin initialized`);
    isInitialized = true;
  }
  
  return {
    config: configureKiloCodeProvider
  };
};

// Export as default
export default KiloCodeProviderPlugin;