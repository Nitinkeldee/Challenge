
LOCAL_CODE_DIR="/path/to/local/code"
REMOTE_USER="azureuser"
REMOTE_HOST="20.127.216.25"
REMOTE_DEPLOY_DIR="/path/to/remote/deployment"
SSH_KEY="/path/to/your/ssh/key"

LOGFILE="deploy.log"
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a $LOGFILE
}

log "Starting deployment..."

if scp -i $SSH_KEY -r $LOCAL_CODE_DIR $REMOTE_USER@$REMOTE_HOST:$REMOTE_DEPLOY_DIR >> $LOGFILE 2>&1; then
    log "File transfer successful."
else
    log "File transfer failed. Exiting..."
    exit 1
fi

ssh -i $SSH_KEY $REMOTE_USER@$REMOTE_HOST << EOF
    set -e
    cd $REMOTE_DEPLOY_DIR
    # Example deployment commands
    # git pull origin main
    # npm install
    # npm run build
    echo "Deployment commands executed."
EOF

if [ $? -eq 0 ]; then
    log "Deployment successful."
else
    log "Deployment failed during remote execution. Exiting..."
    exit 1
fi

log "Sending deployment notification..."
log "Deployment process completed."