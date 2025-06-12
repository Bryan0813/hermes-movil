import 'package:flutter/material.dart';

class MenuWidget extends StatefulWidget {
  const MenuWidget({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<MenuWidget> createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: (value) => {
        if (value == 0)
          {Navigator.pushNamed(context, "/home")}
        else if (value == 1)
          {Navigator.pushNamed(context, "/profile")},
      },
      currentIndex: widget.currentIndex,
      backgroundColor: Colors.lightBlue.shade400,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.lightBlue.shade100,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month),
          label: "Programación",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: "Perfil",
        ),
      ],
    );
  }
}
