# OpenCode Kilocode Plugin

A powerful plugin that integrates Kilocode AI models with OpenCode, providing access to multiple AI providers through OpenRouter API with intelligent model fallbacks.

![Kilocode Plugin](https://img.shields.io/badge/OpenCode-Plugin-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![macOS](https://img.shields.io/badge/platform-macOS-lightgrey)

## Features

- 🤖 **Multiple AI Models**: Access to 340+ AI models through OpenRouter
- 🔄 **Smart Fallbacks**: Automatic fallback to cached models when API is unavailable
- 🚀 **Easy Installation**: One-command installation script
- ⚡ **Fast Response**: Optimized model selection and caching
- 🔧 **Auto Configuration**: Automatically configures OpenCode settings
- 📊 **Model Management**: Dynamic model fetching and management

## Supported Models

The plugin provides access to models from major AI providers including:

- OpenAI (GPT-4, GPT-3.5, o1, o3 series)
- Anthropic (Claude 3.5, Claude 4 series)
- Google (Gemini 2.5, Gemma series)
- Meta (Llama 3.3, Llama 4 series)
- DeepSeek (R1, V3 series)
- Qwen, Mistral, xAI Grok, and many more

## Prerequisites

- **macOS** (tested on macOS 10.15+)
- **Node.js** (v14+ recommended)
- **OpenCode** installed
- **curl** (for downloading)
- **jq** (auto-installed via Homebrew if missing)

## Quick Installation

### One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/nykadamec/opencode_kilocode/refs/heads/main/install_opencode_kilocode.sh | bash
```

### Manual Installation

1. **Download the installer:**
   ```bash
   curl -fsSL https://raw.githubusercontent.com/nykadamec/opencode_kilocode/refs/heads/main/install_opencode_kilocode.sh -o install_kilocode.sh
   chmod +x install_kilocode.sh
   ```

2. **Run the installer:**
   ```bash
   ./install_kilocode.sh
   ```

3. **Set your API key:**
   ```bash
   export KILOCODE_API_KEY='your_api_key_here'
   ```

### Installation Options

- **Standard installation:** `./install_kilocode.sh`
- **Force re-download:** `./install_kilocode.sh force`
- **Show help:** `./install_kilocode.sh help`

## Configuration

### API Key Setup

Get your API key from [Kilocode Dashboard](https://app.kilocode.ai/profile) and set it up:

**Temporary (current session only):**
```bash
export KILOCODE_API_KEY='your_api_key_here'
```

**Permanent (recommended):**
Add to your shell profile (`~/.zshrc` or `~/.bashrc`):
```bash
echo 'export KILOCODE_API_KEY="your_api_key_here"' >> ~/.zshrc
source ~/.zshrc
```

### OpenCode Configuration

The installer automatically updates your `opencode.json`:

```json
{
  "$schema": "https://opencode.ai/config.json",
  "plugin": [
    "./plugin/kilocode/plugin_kilocode.ts"
  ]
}
```

## Usage

After installation and configuration:

1. **Restart OpenCode** to load the plugin
2. **Select models** from the Kilocode provider
3. **Start coding** with AI assistance

The plugin will automatically:
- Fetch available models from OpenRouter
- Use cached fallback models if API is unavailable
- Handle authentication and requests

## Plugin Structure

```
~/.config/opencode/
├── plugin/
│   └── kilocode/
│       ├── plugin_kilocode.ts      # Main plugin file
│       └── models_kilocode.ts      # Model definitions and API handling
├── opencode.json                   # OpenCode configuration
└── install_kilocode.sh            # Installation script
```

## Troubleshooting

### Common Issues

**Plugin not loading:**
- Ensure OpenCode is restarted after installation
- Check that `opencode.json` contains the plugin entry
- Verify plugin files exist in `~/.config/opencode/plugin/kilocode/`

**API errors:**
- Verify your API key is set correctly
- Check API key permissions at [Kilocode Dashboard](https://app.kilocode.ai/profile)
- Ensure network connectivity

**Installation failures:**
- Check system requirements (Node.js, curl, jq)
- Verify OpenCode is installed
- Run with `./install_kilocode.sh force` to re-download

### System Requirements Check

The installer automatically checks for:
- Node.js installation
- OpenCode installation (multiple detection methods)
- Required tools (curl, jq)

### Logs and Debugging

Check OpenCode logs for plugin-related messages:
- Plugin loading status
- API call results
- Error messages

## Development

### Plugin Architecture

The plugin consists of two main components:

1. **plugin_kilocode.ts**: Main plugin interface
   - Implements OpenCode plugin API
   - Handles model selection and requests
   - Manages configuration

2. **models_kilocode.ts**: Model management
   - Fetches available models from OpenRouter API
   - Provides fallback models when API is unavailable
   - Caches model definitions

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Support

- **Documentation**: [GitHub Repository](https://github.com/nykadamec/opencode_kilocode)
- **Issues**: [GitHub Issues](https://github.com/nykadamec/opencode_kilocode/issues)
- **API Keys**: [Kilocode Dashboard](https://app.kilocode.ai/profile)

## Changelog

### Latest Updates
- Added 340+ AI models support
- Improved fallback mechanism
- Enhanced installation script with system checks
- Added force download option
- Better error handling and logging

---

Made with ❤️ for the OpenCode community
