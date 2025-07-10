import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../models/task.dart';
import '../providers/app_provider.dart';
import '../utils/theme.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'user_avatar.dart';

class CreateTaskModal extends StatefulWidget {
  final User user;

  const CreateTaskModal({
    super.key,
    required this.user,
  });

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  DateTime? _dueDate;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppTheme.primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null) {
      setState(() {
        _dueDate = date;
      });
    }
  }

  Future<void> _createTask() async {
    if (!_formKey.currentState!.validate() || _dueDate == null) {
      if (_dueDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a due date'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      context.read<AppProvider>().createTask(
            title: _titleController.text.trim(),
            description: _descriptionController.text.trim().isEmpty
                ? null
                : _descriptionController.text.trim(),
            priority: _priority,
            dueDate: _dueDate!,
            assignedTo: widget.user.id,
          );

      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task assigned to ${widget.user.name}'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create task'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Assign Task',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),

          // Target User
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                UserAvatar(
                  imageUrl: widget.user.photo,
                  name: widget.user.name,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      '@${widget.user.username}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleController,
                      label: 'Task Title',
                      hintText: 'Enter task title',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a task title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    CustomTextField(
                      controller: _descriptionController,
                      label: 'Description (optional)',
                      hintText: 'Add task details...',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 20),

                    // Priority Selection
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Priority',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: TaskPriority.values.map((priority) {
                            final isSelected = _priority == priority;
                            Color color;
                            switch (priority) {
                              case TaskPriority.high:
                                color = AppTheme.errorColor;
                                break;
                              case TaskPriority.medium:
                                color = AppTheme.warningColor;
                                break;
                              case TaskPriority.low:
                                color = AppTheme.accentColor;
                                break;
                            }

                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: priority != TaskPriority.low ? 8 : 0,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _priority = priority;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? color.withOpacity(0.1)
                                          : AppTheme.backgroundColor,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: isSelected
                                            ? color
                                            : const Color(0xFFE5E7EB),
                                      ),
                                    ),
                                    child: Text(
                                      priority.toString().split('.').last.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? color : AppTheme.textSecondary,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Due Date
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              color: AppTheme.textTertiary,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              _dueDate != null
                                  ? 'Due: ${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                  : 'Select due date',
                              style: TextStyle(
                                fontSize: 16,
                                color: _dueDate != null
                                    ? AppTheme.textPrimary
                                    : AppTheme.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const Spacer(),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () => Navigator.of(context).pop(),
                            isOutlined: true,
                            child: const Text('Cancel'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: CustomButton(
                            onPressed: _createTask,
                            isLoading: _isLoading,
                            child: const Text('Assign Task'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}