#!/usr/bin/env bash
set -euo pipefail

# Nexus - Multi-Agent System Installer
# Installs/updates VS Code custom agents and Claude Code skills
# Supports: macOS, Linux, Windows (Git Bash / WSL / MSYS2)

VERSION="1.0.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ─── Colors ───────────────────────────────────────────────────────────────────
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ─── Helpers ──────────────────────────────────────────────────────────────────
info()    { echo -e "${BLUE}[INFO]${NC} $*"; }
success() { echo -e "${GREEN}[OK]${NC} $*"; }
warn()    { echo -e "${YELLOW}[WARN]${NC} $*"; }
error()   { echo -e "${RED}[ERROR]${NC} $*" >&2; }

banner() {
  echo -e "${CYAN}${BOLD}"
  echo "╔══════════════════════════════════════════╗"
  echo "║     Nexus Multi-Agent System Installer   ║"
  echo "║                 v${VERSION}                   ║"
  echo "╚══════════════════════════════════════════╝"
  echo -e "${NC}"
}

usage() {
  cat <<EOF
Usage: $(basename "$0") [OPTIONS]

Install or update Nexus agents and skills.

OPTIONS:
  --agents-only     Install only VS Code custom agents
  --skills-only     Install only Claude Code skills
  --vscode TYPE     VS Code variant: "stable" or "insiders" (default: auto-detect)
  --uninstall       Remove all installed agents and skills
  --dry-run         Show what would be done without making changes
  --help            Show this help message

EXAMPLES:
  $(basename "$0")                        # Install everything (auto-detect)
  $(basename "$0") --agents-only          # Only install VS Code agents
  $(basename "$0") --skills-only          # Only install Claude Code skills
  $(basename "$0") --vscode stable        # Target stable VS Code
  $(basename "$0") --uninstall            # Remove all installations
EOF
}

# ─── OS Detection ─────────────────────────────────────────────────────────────
detect_os() {
  case "$(uname -s)" in
    Darwin)  echo "macos" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    MINGW*|MSYS*|CYGWIN*)
      echo "windows"
      ;;
    *)
      error "Unsupported OS: $(uname -s)"
      exit 1
      ;;
  esac
}

# ─── VS Code Path Resolution ─────────────────────────────────────────────────
get_vscode_prompts_dir() {
  local os="$1"
  local variant="$2"  # "stable" or "insiders"

  local dir_name="Code"
  if [[ "$variant" == "insiders" ]]; then
    dir_name="Code - Insiders"
  fi

  case "$os" in
    macos)
      echo "${HOME}/Library/Application Support/${dir_name}/User/prompts"
      ;;
    linux)
      echo "${HOME}/.config/${dir_name}/User/prompts"
      ;;
    wsl)
      # WSL: check for Windows VS Code path via /mnt/c
      local win_appdata
      win_appdata="$(cmd.exe /C "echo %APPDATA%" 2>/dev/null | tr -d '\r' || true)"
      if [[ -n "$win_appdata" ]]; then
        # Convert Windows path to WSL path
        local wsl_path
        wsl_path="$(wslpath "$win_appdata" 2>/dev/null || echo "")"
        if [[ -n "$wsl_path" ]]; then
          echo "${wsl_path}/${dir_name}/User/prompts"
          return
        fi
      fi
      # Fallback: try common WSL mount
      echo "/mnt/c/Users/$(whoami)/AppData/Roaming/${dir_name}/User/prompts"
      ;;
    windows)
      # Git Bash / MSYS2 on Windows
      echo "${APPDATA}/${dir_name}/User/prompts"
      ;;
  esac
}

# Auto-detect VS Code variant (prefer Insiders if available)
detect_vscode_variant() {
  local os="$1"

  local insiders_dir
  insiders_dir="$(get_vscode_prompts_dir "$os" "insiders")"
  local insiders_parent
  insiders_parent="$(dirname "$(dirname "$insiders_dir")")"

  local stable_dir
  stable_dir="$(get_vscode_prompts_dir "$os" "stable")"
  local stable_parent
  stable_parent="$(dirname "$(dirname "$stable_dir")")"

  if [[ -d "$insiders_parent" ]] && [[ -d "$stable_parent" ]]; then
    echo "both"
  elif [[ -d "$insiders_parent" ]]; then
    echo "insiders"
  elif [[ -d "$stable_parent" ]]; then
    echo "stable"
  else
    echo "none"
  fi
}

# ─── Agent Installation ──────────────────────────────────────────────────────
install_agents() {
  local prompts_dir="$1"
  local dry_run="$2"
  local count=0

  info "Installing VS Code agents to: ${prompts_dir}"

  if [[ "$dry_run" == "true" ]]; then
    info "(dry run) Would create directory: ${prompts_dir}"
  else
    mkdir -p "$prompts_dir"
  fi

  for agent_file in "${SCRIPT_DIR}"/*.agent.md; do
    [[ -f "$agent_file" ]] || continue
    local filename
    filename="$(basename "$agent_file")"

    if [[ "$dry_run" == "true" ]]; then
      info "(dry run) Would copy: ${filename}"
    else
      cp "$agent_file" "${prompts_dir}/${filename}"
      success "Installed: ${filename}"
    fi
    ((count++))
  done

  if [[ $count -eq 0 ]]; then
    warn "No .agent.md files found in ${SCRIPT_DIR}"
  else
    success "Installed ${count} agent(s)"
  fi
}

# ─── Skills Installation ─────────────────────────────────────────────────────
install_skills() {
  local dry_run="$1"
  local skills_dir="${HOME}/.claude/skills"
  local count=0

  info "Installing Claude Code skills to: ${skills_dir}"

  if [[ "$dry_run" == "true" ]]; then
    info "(dry run) Would create directory: ${skills_dir}"
  else
    mkdir -p "$skills_dir"
  fi

  if [[ ! -d "${SCRIPT_DIR}/skills" ]]; then
    warn "No skills/ directory found in ${SCRIPT_DIR}"
    return
  fi

  for skill_dir in "${SCRIPT_DIR}"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target="${skills_dir}/${skill_name}"

    if [[ "$dry_run" == "true" ]]; then
      info "(dry run) Would symlink: ${skill_name} → ${skill_dir}"
    else
      # Remove existing symlink or directory
      if [[ -L "$target" ]]; then
        rm "$target"
      elif [[ -d "$target" ]]; then
        warn "Replacing existing directory: ${target}"
        rm -rf "$target"
      fi
      ln -s "$skill_dir" "$target"
      success "Linked: ${skill_name}"
    fi
    ((count++))
  done

  if [[ $count -eq 0 ]]; then
    warn "No skills found in ${SCRIPT_DIR}/skills/"
  else
    success "Installed ${count} skill(s)"
  fi
}

# ─── Uninstall ────────────────────────────────────────────────────────────────
uninstall_agents() {
  local prompts_dir="$1"
  local dry_run="$2"
  local count=0

  info "Removing agents from: ${prompts_dir}"

  for agent_file in "${SCRIPT_DIR}"/*.agent.md; do
    [[ -f "$agent_file" ]] || continue
    local filename
    filename="$(basename "$agent_file")"
    local target="${prompts_dir}/${filename}"

    if [[ -f "$target" ]]; then
      if [[ "$dry_run" == "true" ]]; then
        info "(dry run) Would remove: ${filename}"
      else
        rm "$target"
        success "Removed: ${filename}"
      fi
      ((count++))
    fi
  done

  if [[ $count -eq 0 ]]; then
    info "No agents found to remove"
  else
    success "Removed ${count} agent(s)"
  fi
}

uninstall_skills() {
  local dry_run="$1"
  local skills_dir="${HOME}/.claude/skills"
  local count=0

  info "Removing skills from: ${skills_dir}"

  if [[ ! -d "${SCRIPT_DIR}/skills" ]]; then
    return
  fi

  for skill_dir in "${SCRIPT_DIR}"/skills/*/; do
    [[ -d "$skill_dir" ]] || continue
    local skill_name
    skill_name="$(basename "$skill_dir")"
    local target="${skills_dir}/${skill_name}"

    if [[ -L "$target" ]] || [[ -d "$target" ]]; then
      if [[ "$dry_run" == "true" ]]; then
        info "(dry run) Would remove: ${skill_name}"
      else
        rm -rf "$target"
        success "Removed: ${skill_name}"
      fi
      ((count++))
    fi
  done

  if [[ $count -eq 0 ]]; then
    info "No skills found to remove"
  else
    success "Removed ${count} skill(s)"
  fi
}

# ─── VS Code Settings Check ──────────────────────────────────────────────────
check_vscode_settings() {
  local os="$1"
  local variant="$2"

  local dir_name="Code"
  [[ "$variant" == "insiders" ]] && dir_name="Code - Insiders"

  local settings_file
  case "$os" in
    macos)  settings_file="${HOME}/Library/Application Support/${dir_name}/User/settings.json" ;;
    linux)  settings_file="${HOME}/.config/${dir_name}/User/settings.json" ;;
    wsl|windows) return ;; # Skip check for Windows paths
  esac

  if [[ -f "$settings_file" ]]; then
    local missing=()
    if ! grep -q '"chat.customAgentInSubagent.enabled"' "$settings_file" 2>/dev/null; then
      missing+=("chat.customAgentInSubagent.enabled")
    fi

    if [[ ${#missing[@]} -gt 0 ]]; then
      echo ""
      warn "Recommended VS Code settings not found:"
      echo -e "  Add to your VS Code settings.json:"
      echo -e "  ${CYAN}{${NC}"
      echo -e "  ${CYAN}  \"chat.customAgentInSubagent.enabled\": true,${NC}"
      echo -e "  ${CYAN}  \"github.copilot.chat.responsesApiReasoningEffort\": \"high\"${NC}"
      echo -e "  ${CYAN}}${NC}"
    fi
  fi
}

# ─── Main ─────────────────────────────────────────────────────────────────────
main() {
  local agents_only=false
  local skills_only=false
  local vscode_override=""
  local uninstall=false
  local dry_run=false

  # Parse arguments
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --agents-only) agents_only=true; shift ;;
      --skills-only) skills_only=true; shift ;;
      --vscode)
        shift
        vscode_override="${1:-}"
        if [[ "$vscode_override" != "stable" ]] && [[ "$vscode_override" != "insiders" ]]; then
          error "Invalid --vscode value: '$vscode_override'. Use 'stable' or 'insiders'."
          exit 1
        fi
        shift
        ;;
      --uninstall) uninstall=true; shift ;;
      --dry-run)   dry_run=true; shift ;;
      --help|-h)   usage; exit 0 ;;
      *)
        error "Unknown option: $1"
        usage
        exit 1
        ;;
    esac
  done

  banner

  # Detect OS
  local os
  os="$(detect_os)"
  info "Detected OS: ${BOLD}${os}${NC}"

  # Resolve action
  local install_agents_flag=true
  local install_skills_flag=true
  if [[ "$agents_only" == "true" ]]; then
    install_skills_flag=false
  fi
  if [[ "$skills_only" == "true" ]]; then
    install_agents_flag=false
  fi

  if [[ "$dry_run" == "true" ]]; then
    warn "Dry run mode — no changes will be made"
    echo ""
  fi

  # ── Agents ──
  if [[ "$install_agents_flag" == "true" ]]; then
    local variants=()

    if [[ -n "$vscode_override" ]]; then
      variants=("$vscode_override")
    else
      local detected
      detected="$(detect_vscode_variant "$os")"
      case "$detected" in
        both)
          info "Found both VS Code Stable and Insiders"
          variants=("stable" "insiders")
          ;;
        insiders) variants=("insiders") ;;
        stable)   variants=("stable") ;;
        none)
          warn "No VS Code installation detected"
          warn "Specify variant with --vscode stable|insiders"
          ;;
      esac
    fi

    for variant in "${variants[@]}"; do
      local prompts_dir
      prompts_dir="$(get_vscode_prompts_dir "$os" "$variant")"
      info "VS Code variant: ${BOLD}${variant}${NC}"

      if [[ "$uninstall" == "true" ]]; then
        uninstall_agents "$prompts_dir" "$dry_run"
      else
        install_agents "$prompts_dir" "$dry_run"
        check_vscode_settings "$os" "$variant"
      fi
      echo ""
    done
  fi

  # ── Skills ──
  if [[ "$install_skills_flag" == "true" ]]; then
    if [[ "$uninstall" == "true" ]]; then
      uninstall_skills "$dry_run"
    else
      install_skills "$dry_run"
    fi
    echo ""
  fi

  # ── Summary ──
  if [[ "$uninstall" == "true" ]]; then
    success "${BOLD}Uninstall complete!${NC}"
  else
    success "${BOLD}Installation complete!${NC}"
    echo ""
    echo -e "  ${BOLD}Next steps:${NC}"
    if [[ "$install_agents_flag" == "true" ]]; then
      echo -e "  1. Reload VS Code: ${CYAN}Ctrl+Shift+P${NC} → \"Developer: Reload Window\""
      echo -e "  2. Open Copilot Chat and type: ${CYAN}@Nexus${NC}"
    fi
    if [[ "$install_skills_flag" == "true" ]]; then
      echo -e "  ${BOLD}Claude Code:${NC} Use ${CYAN}/nexus${NC} or ${CYAN}/nexus-build${NC} etc."
    fi
  fi
}

main "$@"
