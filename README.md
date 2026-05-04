# Random Daily

Self-hosted standup name shuffler. A small bash script that picks a random
order for your team, formats it as a comma-separated list, and POSTs it to a
Slack workflow webhook. Designed to run from cron on a Linux box.

## Requirements

- `bash`, `curl`, `coreutils` (`shuf`) — present by default on Ubuntu
- `jq` — install with `sudo apt install jq`

## Setup

1. Clone this repo somewhere persistent (example below uses `/opt/random-daily`):
   ```sh
   sudo git clone <this-repo> /opt/random-daily
   sudo chown -R "$USER:$USER" /opt/random-daily
   cd /opt/random-daily
   ```

2. Create `config.env` from the template and fill in your values:
   ```sh
   cp config.env.example config.env
   chmod 600 config.env
   $EDITOR config.env
   ```

   - `MEMBERS` — comma-separated names, no spaces (e.g. `Alice,Bob,Charlie`)
   - `WEBHOOK_URL` — your Slack workflow webhook URL

3. Make the script executable:
   ```sh
   chmod +x shuffle.sh
   ```

4. Smoke test it (this will post to Slack):
   ```sh
   ./shuffle.sh
   ```

## Cron

Edit your user's crontab with `crontab -e` and add:

```
30 10 * * 1-5 /opt/random-daily/shuffle.sh
```

This runs Mon–Fri at 10:30 local time. The script exits non-zero on any
failure, so cron will email the local user if something breaks.

## Slack workflow setup

The script POSTs `{"r_list": "Name1, Name2, Name3"}` to the webhook URL.
Configure your Slack workflow with a `r_list` text variable and reference it
in the message body.
