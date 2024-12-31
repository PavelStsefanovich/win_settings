from PySide6.QtWidgets import QApplication, QSystemTrayIcon, QMenu
from PySide6.QtGui import QAction, QIcon
import sys
import subprocess
    
def open_settings(setting):
    subprocess.Popen(["cmd", "/c", f'start ms-settings:{setting}'])

def main():
    app = QApplication(sys.argv)

    # Create the system tray icon
    tray_icon = QSystemTrayIcon()

    # Set an icon for the tray
    tray_icon.setIcon(QIcon("assets/favicon.ico"))

    # Create a menu for the tray icon
    menu = QMenu()

    # Add actions to the menu
    action1  = QAction(QIcon("assets/about.ico"), "About")
    action2  = QAction(QIcon("assets/apps.ico"), "Apps")
    action3  = QAction(QIcon("assets/battery.ico"), "Battery")
    action4  = QAction(QIcon("assets/bluetooth.ico"), "Bluetooth")
    action5  = QAction(QIcon("assets/clipboard.ico"), "Clipboard")
    action6  = QAction(QIcon("assets/datetime.ico"), "Date & Time")
    action7  = QAction(QIcon("assets/defaultapps.ico"), "Default Apps")
    action8  = QAction(QIcon("assets/dev.ico"), "Developers")
    action9  = QAction(QIcon("assets/display.ico"), "Display")
    action10 = QAction(QIcon("assets/fonts.ico"), "Fonts")
    action11 = QAction(QIcon("assets/gamebar.ico"), "Game Bar")
    action12 = QAction(QIcon("assets/keyboard.ico"), "Keyboard")
    action13 = QAction(QIcon("assets/lockscreen.ico"), "Lock Screen")
    action14 = QAction(QIcon("assets/mobile.ico"), "Mobile Devices")
    action15 = QAction(QIcon("assets/mouse.ico"), "Mouse & Touchpad")
    action16 = QAction(QIcon("assets/network.ico"), "Network")
    action17 = QAction(QIcon("assets/notifications.ico"), "Notifications")
    action18 = QAction(QIcon("assets/winfeatures.ico"), "Optional Features")
    action19 = QAction(QIcon("assets/personalization.ico"), "Personalization")
    action20 = QAction(QIcon("assets/power.ico"), "Power & Sleep")
    action21 = QAction(QIcon("assets/printers.ico"), "Printers")
    action22 = QAction(QIcon("assets/privacy.ico"), "Privacy")
    action23 = QAction(QIcon("assets/recovery.ico"), "Recovery")
    action24 = QAction(QIcon("assets/sound.ico"), "Sound")
    action25 = QAction(QIcon("assets/startup.ico"), "Startup Apps")
    action26 = QAction(QIcon("assets/sync.ico"), "Sync")
    action27 = QAction(QIcon("assets/defender.ico"), "Windows Defender")
    action28 = QAction(QIcon("assets/winupdate.ico"), "Windows Update")
    action29 = QAction(QIcon("assets/whoami.ico"), "Your Info")
    quit_action = QAction(QIcon("assets/quit.ico"), "Quit")

    # Connect actions to functions
    action1.triggered.connect(lambda: open_settings("about"))
    action2.triggered.connect(lambda: open_settings("appsfeatures"))
    action3.triggered.connect(lambda: open_settings("batterysaver"))
    action4.triggered.connect(lambda: open_settings("bluetooth"))
    action5.triggered.connect(lambda: open_settings("clipboard"))
    action6.triggered.connect(lambda: open_settings("dateandtime"))
    action7.triggered.connect(lambda: open_settings("defaultapps"))
    action8.triggered.connect(lambda: open_settings("developers"))
    action9.triggered.connect(lambda: open_settings("display"))
    action10.triggered.connect(lambda: open_settings("fonts"))
    action11.triggered.connect(lambda: open_settings("gaming-gamebar"))
    action12.triggered.connect(lambda: open_settings("keyboard"))
    action13.triggered.connect(lambda: open_settings("lockscreen"))
    action14.triggered.connect(lambda: open_settings("mobile-devices"))
    action15.triggered.connect(lambda: open_settings("mousetouchpad"))
    action16.triggered.connect(lambda: open_settings("network"))
    action17.triggered.connect(lambda: open_settings("notifications"))
    action18.triggered.connect(lambda: open_settings("optionalfeatures"))
    action19.triggered.connect(lambda: open_settings("personalization"))
    action20.triggered.connect(lambda: open_settings("powersleep"))
    action21.triggered.connect(lambda: open_settings("printers"))
    action22.triggered.connect(lambda: open_settings("privacy"))
    action23.triggered.connect(lambda: open_settings("recovery"))
    action24.triggered.connect(lambda: open_settings("sound"))
    action25.triggered.connect(lambda: open_settings("startupapps"))
    action26.triggered.connect(lambda: open_settings("sync"))
    action27.triggered.connect(lambda: open_settings("windowsdefender"))
    action28.triggered.connect(lambda: open_settings("windowsupdate"))
    action29.triggered.connect(lambda: open_settings("yourinfo"))
    quit_action.triggered.connect(app.quit)

    # Add actions to the menu
    menu.addAction(action1)
    menu.addAction(action2)
    menu.addAction(action3)
    menu.addAction(action4)
    menu.addAction(action5)
    menu.addAction(action6)
    menu.addAction(action7)
    menu.addAction(action8)
    menu.addAction(action9)
    menu.addAction(action10)
    menu.addAction(action11)
    menu.addAction(action12)
    menu.addAction(action13)
    menu.addAction(action14)
    menu.addAction(action15)
    menu.addAction(action16)
    menu.addAction(action17)
    menu.addAction(action18)
    menu.addAction(action19)
    menu.addAction(action20)
    menu.addAction(action21)
    menu.addAction(action22)
    menu.addAction(action23)
    menu.addAction(action24)
    menu.addAction(action25)
    menu.addAction(action26)
    menu.addAction(action27)
    menu.addAction(action28)
    menu.addAction(action29)
    menu.addSeparator()
    menu.addAction(quit_action)

    # Set the menu to the tray icon
    tray_icon.setContextMenu(menu)
    tray_icon.show()

    sys.exit(app.exec())

if __name__ == "__main__":
    main()