<div align="center">
  <img src="./_assets/logo.png" align="center" alt="container-use" />
  <h2 align="center">container-use</h2>
  <p align="center">Containerized environments for coding agents. (📦🤖) (📦🤖) (📦🤖)</p>

  <p align="center">
    <img src="https://img.shields.io/badge/stability-experimental-orange.svg" alt="Experimental" />
    <a href="https://opensource.org/licenses/Apache-2.0">
      <img src="https://img.shields.io/badge/License-Apache_2.0-blue.svg">
    </a>
    <a href="https://discord.gg/UhXqKz7SRM">
      <img src="https://img.shields.io/discord/707636530424053791?logo=discord&logoColor=white&label=Discord&color=7289DA" alt="Discord">
    </a>
  </p>
</div>

**Container Use** lets each of your coding agents have their own containerized environment. Go from babysitting one agent at a time to enabling multiple agents to work safely and independently with your preferred stack.

<p align='center'>
    <img src='./_assets/demo.gif' width='700' alt='container-use demo'>
</p>

It's an open-source MCP server that works as a CLI tool with Claude Code, Cursor, and other MCP-compatible agents.

* 📦 **Isolated Environments**: Each agent gets a fresh container in its own git branch - run multiple agents without conflicts, experiment safely, discard failures instantly.
* 👀 **Real-time Visibility**: See complete command history and logs of what agents actually did, not just what they claim.
* 🚁 **Direct Intervention**: Drop into any agent's terminal to see their state and take control when they get stuck.
* 🎮 **Environment Control**: Standard git workflow - just `git checkout <branch_name>` to review any agent's work.
* 🌎 **Universal Compatibility**: Works with any agent, model, or infrastructure - no vendor lock-in.

---

🦺 This project is in early development and actively evolving. Expect rough edges, breaking changes, and incomplete documentation - but also expect rapid iteration and responsiveness to feedback.

---

## Installing

### Linux/macOS

```sh
make
```

This will build the `cu` binary but _NOT_ install it to your `$PATH`. If you want to build and install the binary into your `$PATH`, run:

```sh
make install && hash -r
```

### Windows

To build for Windows, use:

```sh
make build-local-windows
```

This will create a `cu.exe` binary for Windows. Alternatively, you can build directly with Go:

```sh
GOOS=windows GOARCH=amd64 go build -o cu.exe ./cmd/cu
```

### Alternative Build Methods

For local development without Docker:

```sh
# Linux/macOS
make build-local

# Windows
make build-local-windows
```

The `make install` command will put `cu` in your `$PATH`. In order to use it, you will need to restart your terminal or run `hash -r` to refresh your `$PATH` (or equivalent for your shell).

## Agent Integration

Enabling `container-use` requires 2 steps:

1. Adding an MCP configuration for `container-use`
2. (Optional) Adding a rule so the agent uses containarized environments.

### [Claude Code](https://docs.anthropic.com/en/docs/claude-code/tutorials#set-up-model-context-protocol-mcp)

```sh
# Add the container-use MCP
npx @anthropic-ai/claude-code mcp add container-use -- <path to cu> stdio

# Save the CLAUDE.md file at the root of the repository. Alternatively, merge the instructions into your own CLAUDE.md.
curl -o CLAUDE.md https://raw.githubusercontent.com/dagger/container-use/main/rules/agent.md
```

### [goose](https://block.github.io/goose/docs/getting-started/using-extensions#mcp-servers)

Add this to `~/.config/goose/config.yaml`:

```yaml
extensions:
  container-use:
    name: container-use
    type: stdio
    enabled: true
    cmd: cu
    args:
    - stdio
    envs: {}
```

### [Cursor](https://docs.cursor.com/context/model-context-protocol)

```sh
curl --create-dirs -o .cursor/rules/container-use.mdc https://raw.githubusercontent.com/dagger/container-use/main/rules/cursor.mdc
```

### [VSCode](https://code.visualstudio.com/docs/copilot/chat/mcp-servers) / [GitHub Copilot](https://docs.github.com/en/copilot/customizing-copilot/extending-copilot-chat-with-mcp)

```sh
curl --create-dirs -o .github/copilot-instructions.md https://raw.githubusercontent.com/dagger/container-use/main/rules/agent.md
```
### [Kilo Code](https://kilocode.ai/docs/features/mcp/using-mcp-in-kilo-code)

`Kilo Code` allows setting MCP servers at global or project level - chose any as appropriate for your case. The video shows MCP server setting at global level.

<p align='center'>
    <img src='./_assets/kilo-code-set-mcp-server.gif' width='300' alt='container-use kilo code mcp setting'>
</p>

```json
{
  "mcpServers": {
    "container-use": {
      "command": "replace with pathname of cu",
      "args": [
        "stdio"
      ],
      "env": {},
      "alwaysAllow": [],
      "disabled": false
    }
  }
}
```

## Examples

| Example | Description |
|---------|-------------|
| [hello_world.md](examples/hello_world.md) | Creates a simple app and runs it, accessible via localhost HTTP URL |
| [parallel.md](examples/parallel.md) | Creates and serves two variations of a hello world app (Flask and FastAPI) on different URLs |
| [security.md](examples/security.md) | Security scanning example that checks for updates/vulnerabilities in the repository, applies updates, verifies builds still work, and generates patch file |

### Run with [Claude Code](https://www.anthropic.com/claude-code)

```console
cat ./examples/hello_world.md | claude
```

### Run with [goose](https://block.github.io/goose/)

```console
goose run -i ./examples/hello_world.md -s
```

### Run with [Kilo Code](https://kilocode.ai/) in `vscode`

Prompt as in `parallel.md` but added a sentence 'use container-use mcp'

<p align='center'>
    <img src='./_assets/run-with-kilo-code.gif' width='300' alt='container-use kilo code'>
</p>

## Watching your agents work

Your agents will automatically commit to a container-use remote on your local filesystem. You can watch the progress of your agents in real time by running:

```console
cu watch
```
