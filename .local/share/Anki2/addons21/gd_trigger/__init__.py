import subprocess
from anki.hooks import addHook
from aqt import mw


def on_show_answer():
    # 1. Get the current card and note
    card = mw.reviewer.card
    if not card:
        return

    note = card.note()

    # 2. Get the word from your specific field
    # CHANGE "Front" to your actual field name (e.g., "Word", "Expression")
    word = note["word"].strip()

    if word:
        # 3. Call GoldenDict directly
        # 'goldendict' is the command; 'word' is the argument
        subprocess.Popen(["goldendict", word])
        
        # 3. Tell bspwm to focus Anki's ID specifically
        # We use a tiny delay (0.05) to ensure the focus move happens 
        # AFTER the window manager registers GoldenDict's arrival.
        subprocess.Popen(["sh", "-c", "sleep 0.2 && bspc node last -f"])

# Link this function to Anki's "Show Answer" event
addHook("showAnswer", on_show_answer)

