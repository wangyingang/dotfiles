# $ZDOTDIR/conf.d/ai-model.zsh
#
# Local inference model library and helpers.
# XDG base directories are defined in $ZDOTDIR/.zshenv.

# Long-lived local model assets.
export AI_HOME="${AI_HOME:-$XDG_DATA_HOME/ai}"
export AI_MODEL_HOME="${AI_MODEL_HOME:-$AI_HOME/models}"
export MLX_MODEL_HOME="${MLX_MODEL_HOME:-$AI_MODEL_HOME/mlx}"
export GGUF_MODEL_HOME="${GGUF_MODEL_HOME:-$AI_MODEL_HOME/gguf}"
export EMBEDDING_MODEL_HOME="${EMBEDDING_MODEL_HOME:-$AI_MODEL_HOME/embedding}"

# Runtime caches. These are rebuildable and should not be treated as model assets.
export OMLX_CACHE="${OMLX_CACHE:-$XDG_CACHE_HOME/omlx/kv-cache}"
export LLAMA_CACHE="${LLAMA_CACHE:-$XDG_CACHE_HOME/llama.cpp}"

# Hugging Face cache and credential location.
export HF_HOME="${HF_HOME:-$XDG_CACHE_HOME/huggingface}"
export HF_HUB_CACHE="${HF_HUB_CACHE:-$HF_HOME/hub}"
export HF_XET_CACHE="${HF_XET_CACHE:-$HF_HOME/xet}"
export HF_ASSETS_CACHE="${HF_ASSETS_CACHE:-$HF_HOME/assets}"
export HF_STATE_HOME="${HF_STATE_HOME:-$XDG_STATE_HOME/huggingface}"
export HF_TOKEN_PATH="${HF_TOKEN_PATH:-$HF_STATE_HOME/token}"

function ai-model() {
  emulate -L zsh
  setopt err_return no_unset pipe_fail

  local cmd="${1:-}"
  (( $# == 0 )) || shift

  case "$cmd" in
    init)
      mkdir -p \
        "$MLX_MODEL_HOME" \
        "$GGUF_MODEL_HOME" \
        "$EMBEDDING_MODEL_HOME" \
        "$AI_MODEL_HOME/archive/mlx" \
        "$AI_MODEL_HOME/archive/gguf" \
        "$OMLX_CACHE" \
        "$LLAMA_CACHE" \
        "$HF_HUB_CACHE" \
        "$HF_XET_CACHE" \
        "$HF_ASSETS_CACHE" \
        "$HF_STATE_HOME" 2>/dev/null || return $?
      chmod 700 "$HF_STATE_HOME" 2>/dev/null || true
      ;;

    path)
      case "${1:-all}" in
        all)
          print -- "AI_MODEL_HOME=$AI_MODEL_HOME"
          print -- "MLX_MODEL_HOME=$MLX_MODEL_HOME"
          print -- "GGUF_MODEL_HOME=$GGUF_MODEL_HOME"
          print -- "EMBEDDING_MODEL_HOME=$EMBEDDING_MODEL_HOME"
          ;;
        mlx) print -- "$MLX_MODEL_HOME" ;;
        gguf) print -- "$GGUF_MODEL_HOME" ;;
        embedding) print -- "$EMBEDDING_MODEL_HOME" ;;
        *)
          print -u2 "usage: ai-model path [all|mlx|gguf|embedding]"
          return 2
          ;;
      esac
      ;;

    du)
      case "${1:-all}" in
        all) du -sh "$AI_MODEL_HOME"/* 2>/dev/null || true ;;
        mlx) du -sh "$MLX_MODEL_HOME" 2>/dev/null || true ;;
        gguf) du -sh "$GGUF_MODEL_HOME" 2>/dev/null || true ;;
        embedding) du -sh "$EMBEDDING_MODEL_HOME" 2>/dev/null || true ;;
        *)
          print -u2 "usage: ai-model du [all|mlx|gguf|embedding]"
          return 2
          ;;
      esac
      ;;

    list)
      case "${1:-all}" in
        all)
          print -- "[mlx]"
          find "$MLX_MODEL_HOME" -maxdepth 3 -type f \
            \( -name 'config.json' -o -name '*.safetensors' \) 2>/dev/null || true
          print -- ""
          print -- "[gguf]"
          find "$GGUF_MODEL_HOME" -type f -name '*.gguf' 2>/dev/null || true
          ;;
        mlx)
          find "$MLX_MODEL_HOME" -maxdepth 3 -type f \
            \( -name 'config.json' -o -name '*.safetensors' \) 2>/dev/null || true
          ;;
        gguf)
          find "$GGUF_MODEL_HOME" -type f -name '*.gguf' 2>/dev/null || true
          ;;
        *)
          print -u2 "usage: ai-model list [all|mlx|gguf]"
          return 2
          ;;
      esac
      ;;

    download)
      local kind="${1:-}"
      (( $# == 0 )) || shift

      case "$kind" in
        mlx)
          if (( $# != 1 )); then
            print -u2 "usage: ai-model download mlx <org/repo>"
            return 2
          fi

          local repo="$1"
          local dest="$MLX_MODEL_HOME/$repo"
          mkdir -p "$dest"
          hf download "$repo" --local-dir "$dest"
          ;;

        gguf)
          if (( $# != 2 )); then
            print -u2 "usage: ai-model download gguf <org/repo> <file.gguf>"
            return 2
          fi

          local repo="$1"
          local file="$2"
          local dest="$GGUF_MODEL_HOME/$repo"
          mkdir -p "$dest"
          hf download "$repo" "$file" --local-dir "$dest"
          ;;

        *)
          print -u2 "usage: ai-model download <mlx|gguf> ..."
          return 2
          ;;
      esac
      ;;

    help|-h|--help|'')
      cat <<'USAGE'
usage:
  ai-model init
  ai-model path [all|mlx|gguf|embedding]
  ai-model du [all|mlx|gguf|embedding]
  ai-model list [all|mlx|gguf]
  ai-model download mlx <org/repo>
  ai-model download gguf <org/repo> <file.gguf>
USAGE
      ;;

    *)
      print -u2 "ai-model: unknown command: $cmd"
      print -u2 "run: ai-model help"
      return 2
      ;;
  esac
}

function omlx-local() {
  emulate -L zsh
  setopt err_return no_unset

  omlx serve \
    --model-dir "$MLX_MODEL_HOME" \
    --paged-ssd-cache-dir "$OMLX_CACHE"
}

# Keep the local AI directory layout ready whenever this module is sourced.
ai-model init
