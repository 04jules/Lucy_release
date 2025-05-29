import tkinter as tk
import random

import sys
import os

def resource_path(relative_path):
    try:
        base_path = sys._MEIPASS
    except Exception:
        base_path = os.path.abspath(".")
    return os.path.join(base_path, relative_path)

VERSIE = "v0.1"
gespreksgeschiedenis = []

def antwoord_genereren(gebruikersinput):
    if gebruikersinput.startswith("/"):
        if gebruikersinput == "/help":
            return "Beschikbare commando’s zijn: /help, /versie"
        elif gebruikersinput == "/versie":
            return f"Je gebruikt Lucy versie {VERSIE}"
        else:
            return "Onbekend commando."
            
    if "hallo" in gebruikersinput.lower():
        keuzes = [
            "Lucy: Hallo? Wie ben jij?",
            "Lucy: Hallo! Hier ben ik dan!",
            "Lucy: Hallo wereld! Is dit hoe mensen dit doen?"
        ]
        return random.choice(keuzes)
        
        
    return f"Lucy: Je zei '{gebruikersinput}'"

def verwerk_input():
    gebruikersinput = inputveld.get()
    if not gebruikersinput.strip():
        return  # negeer lege input

    antwoord = antwoord_genereren(gebruikersinput)

    gespreksgeschiedenis.append(("Jij", gebruikersinput))
    gespreksgeschiedenis.append(("Lucy", antwoord))

    tekstvenster.config(state="normal")
    tekstvenster.insert(tk.END, f"Jij: {gebruikersinput}\n")
    tekstvenster.insert(tk.END, f"{antwoord}\n\n")
    tekstvenster.config(state="disabled")

    inputveld.delete(0, tk.END) 

def main():
    root = tk.Tk()
    root.title(f"Lucy {VERSIE}")
    
    root.iconbitmap(resource_path("lucy.ico"))

    root.geometry("500x400")
    root.configure(bg="black")

    titel = tk.Label(root, text=f"Welkom bij Lucy {VERSIE}", fg="white", bg="black", font=("Arial", 14))
    titel.pack(pady=10)

    global tekstvenster
    tekstvenster = tk.Text(root, height=12, state="disabled", bg="white", fg="black", wrap="word")
    tekstvenster.pack(padx=10, pady=5)

    global inputveld
    inputveld = tk.Entry(root, width=40)
    inputveld.insert(0, "zeg hallo!")
    inputveld.pack(pady=5)
    
    def wis_placeholder(event):
        if inputveld.get() == "zeg hallo!":
            inputveld.delete(0, tk.END)
           
    inputveld.bind("<FocusIn>", wis_placeholder)


    verzendknop = tk.Button(root, text="Zeg iets", command=verwerk_input)
    verzendknop.pack()

    update_button = tk.Button(root, text="Check op update (nog niet actief)", state="disabled")
    update_button.pack(pady=10)
    
    root.bind("<Return>", lambda event: verwerk_input())

    root.mainloop()

if __name__ == "__main__":
    main()
