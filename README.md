# 🐦 Flappy Bird in x86 Assembly (NASM)

A complete **Flappy Bird clone** written entirely in **x86 Assembly (16-bit)** using **NASM**, running on **DOSBox**.  
Developed as part of the **Computer Organisation and Assembly Language (COAL)** course, this project demonstrates low-level graphics, collision detection, and input handling — all done directly through BIOS interrupts and video memory.

---

## 🎮 Features

- 🕹️ **Play & Pause** functionality  
- 💥 **Accurate Collision Detection** (pipes and ground)  
- 🐤 **Animated Bird** with flapping wings  
- 🌆 **Scrolling Pipes and Background**  
- 🔊 **Optional Sound Effects** (if supported)  
- 🧮 **Score Tracking & Restart Option**  
- ⏱️ **Optimized Timing** using BIOS interrupts  

---

## ⚙️ Technical Details

| Category | Description |
|-----------|--------------|
| **Language** | x86 Assembly (16-bit) |
| **Assembler** | NASM |
| **Emulator** | DOSBox |
| **Video Mode** | VGA Text Mode (0xB800) |
| **BIOS Interrupts Used** | `int 10h` (video), `int 16h` (keyboard), `int 1Ah` (timer) |
| **Memory Access** | Direct video memory manipulation |
| **Platform** | Real-mode x86 (DOS environment) |

---

## 🧠 How It Works

- The **bird** is drawn using ASCII characters and animated by toggling between wing-up and wing-down frames.  
- **Pipes** scroll from right to left by continuously updating the video memory.  
- **Keyboard input** is read via `int 16h`, detecting key presses for flapping (Spacebar) or pausing (ESC).  
- **Collision detection** checks whether the bird’s coordinates overlap with any pipe segment.  
- **Timing control** uses BIOS interrupts to manage frame rate and animation smoothness.  
- **Score counting** increments whenever the bird successfully passes a pipe.

---

## 🚀 How to Run

1. Install **NASM** and **DOSBox** on your system.  
2. Assemble the source code:
   ```bash
   nasm -f bin flappy.asm -o flappy.com


Open DOSBox, mount your project folder, and run:

flappy.com


Controls:

Spacebar → Flap / Jump

ESC → Pause or Exit

📸 Demo
<img width="2999" height="1993" alt="image" src="https://github.com/user-attachments/assets/9481d7c4-bf0c-4c80-95d9-c30da4ea9a07" />
<img width="2998" height="1998" alt="image" src="https://github.com/user-attachments/assets/cb1d6d78-bd0a-4d0d-bdeb-c1234d54c944" />



“A classic game reimagined at the hardware level — one instruction at a time.”

🧩 Project Structure
├── flappy.asm        # Main source code
├── README.md         # Project documentation
└── build/            # Output files (flappy.com, etc.)

📚 Educational Purpose

This project demonstrates key COAL and Assembly concepts, including:

Real-time graphics programming

Direct video memory access

Handling BIOS interrupts

Timing and frame management

Low-level I/O and control flow

It serves as a practical example of how simple game mechanics can be achieved through hardware-level programming.

👨‍💻 Contributors

Your Name

Huzaifa Shabbir

Hamza Naveed

🏁 Acknowledgments

Developed as part of the Computer Organization and Assembly Language (COAL) course

⭐ If you enjoyed this project, please give it a star!
