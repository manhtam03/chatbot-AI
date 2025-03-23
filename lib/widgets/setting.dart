import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chatbot/theme/theme_notifier.dart';

class SettingsDialog extends ConsumerStatefulWidget {
  final VoidCallback onDeleteConversation;

  const SettingsDialog({super.key, required this.onDeleteConversation});

  @override
  ConsumerState<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends ConsumerState<SettingsDialog> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);
    return AlertDialog(
      backgroundColor: (currentTheme == ThemeMode.dark) ? Color(0xFF3E3E3E) : Colors.white,
      title: Text("Cài đặt"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Chế độ tối", style: Theme.of(context).textTheme.titleSmall),
              IconButton(
                onPressed: (){
                  ref.read(themeProvider.notifier).toggleTheme();
                },
                icon: (currentTheme == ThemeMode.dark)
                    ? Icon(Icons.light_mode, color: Theme.of(context).colorScheme.secondary)
                    : Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Xóa đoạn chat", style: Theme.of(context).textTheme.titleSmall),
              IconButton(
                onPressed: () async {
                  bool confirmDelete = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Xóa hội thoại'),
                      content: Text(
                          'Bạn chắc chắn muốn xóa đoạn hội thoại này?',
                        style: Theme.of(context).textTheme.titleSmall
                      ),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('Hủy', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text('Xóa', style: TextStyle(color: Colors.white)),
                        )
                      ],
                    )
                  );
                  if (confirmDelete == true) {
                    widget.onDeleteConversation();
                  }
                },
                icon: Icon(Icons.delete_outline, color: Colors.red,),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Đóng dialog
          child: Text("Đóng"),
        ),
      ],
    );
  }
}
