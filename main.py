from PySide6.QtWidgets import QApplication, QSystemTrayIcon, QMenu
from PySide6.QtGui import QAction, QIcon
import sys


def main():
    app = QApplication(sys.argv)

    # Create the system tray icon
    tray_icon = QSystemTrayIcon()

    # Set an icon for the tray
    tray_icon.setIcon(QIcon("assets/favicon.ico"))

    # Create a menu for the tray icon
    menu = QMenu()

    # Add actions to the menu
    action1 = QAction("Action 1")
    action2 = QAction("Action 2")
    quit_action = QAction("Quit")

    # Connect actions to functions
    quit_action.triggered.connect(app.quit)

    # Add actions to the menu
    menu.addAction(action1)
    menu.addAction(action2)
    menu.addSeparator()
    menu.addAction(quit_action)

    # Set the menu to the tray icon
    tray_icon.setContextMenu(menu)

    # Show the tray icon
    tray_icon.show()

    # Show the tray icon tooltip
    tray_icon.setToolTip("Windows Settings Shortcuts")

    # Start the application event loop
    sys.exit(app.exec())

if __name__ == "__main__":
    main()