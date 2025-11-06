REPO_DIR="$(dirname "$0")/.."
LOG_FILE="$REPO_DIR/logs/autocommit.log"
BRANCH="main"
GIT_USER="$GIT_USER"
GIT_EMAIL="$GIT_EMAIL"


mkdir -p "$REPO_DIR/logs"
cd "$REPO_DIR" || exit

git config user.name "$GIT_USER"
git config user.email "$GIT_EMAIL"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
}

log "=== Iniciando auto-commit ==="

CHANGES=$(git status --porcelain)

if [ -z "$CHANGES" ]; then
    log "No hay cambios para commitear 😴"
else
    git add -A

    ADDED=$(echo "$CHANGES" | grep '^A' | wc -l)
    MODIFIED=$(echo "$CHANGES" | grep '^ M' | wc -l)
    DELETED=$(echo "$CHANGES" | grep '^ D' | wc -l)

    WHAT="Archivos modificados"
    FOR="Mantener el repositorio actualizado"
    IMPACT="Evita perder cambios y mantiene historial"

    SUMMARY=""
    [ "$ADDED" -gt 0 ] && SUMMARY+="➕ Agregados: $ADDED. "
    [ "$MODIFIED" -gt 0 ] && SUMMARY+="✏️ Modificados: $MODIFIED. "
    [ "$DELETED" -gt 0 ] && SUMMARY+="❌ Borrados: $DELETED. "

    COMMIT_MSG="Auto-commit $(date '+%Y-%m-%d %H:%M:%S') | $SUMMARY

What? $WHAT
For? $FOR
Impact? $IMPACT

 Auto-committed by script"

    if git commit -m "$COMMIT_MSG"; then
        log "✅ Commit realizado: $SUMMARY"

        if git push origin "$BRANCH" 2>&1 | tee -a "$LOG_FILE"; then
            log "✅ Push exitoso 👍"
        else
            log "⚠️ Push fallido, se intentará la próxima vez"
        fi
    else
        log "❌ Commit fallido ⚠️"
    fi
fi

log "=== Auto-commit finalizado ==="
echo "" >> "$LOG_FILE"
