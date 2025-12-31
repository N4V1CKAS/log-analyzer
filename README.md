# 📜 Log Analyzer
Quickly inspect system, authentication, Nginx or custom logs from a single interactive menu

# 🛠️ Technologies
- Bash scripting
- Core Linux tools: ```grep, zgrep, awk, sort, uniq, tail, zcat```

# 🚀 Features
- Analyzes common Ubuntu logs
- Analyzes any custom log file path
- Handles compressed logs (.gz) automatically
- Highlights errors, warnings and failed login attempts
- Shows top repeated log messages for quick insight
- User-friendly interactive menu

# 💡 Why I built it
This script was mainly created to practice Linux admin and bash scripting skills:
- Navigating log formats and rotated logs
- Filtering and highlighting important log messages
- Writing safer Bash scripts with strict mode, file checks and handling empty results
- Creating a reusable, menu-driven tool

# 🔍 How it works
The script prints a menu to select which log to analyze, each option prints:
- Last few lines of the log
- Recent errors and warnings
- Top repeated messages or most relevant stats (failed logins, top IPs)
- Optionally, you can input your own custom log path that can be scanned

# 📦 Usage
1. Clone the repository
2. Make the script executable: ```chmod +x analyzer.sh```
3. Run the script (some logs may need sudo): ```./analyzer.sh```
4. Follow the interactive menu to analyze the logs

# 🔮 Planned Improvements
- Smarter error/warning filtering and sorting to show the most relevant messages first
- Optional export to a text file
- Show basic log rotation or size info
- Loop back to the menu instead of exiting
