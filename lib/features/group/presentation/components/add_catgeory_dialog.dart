import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:teatally/core/styles/text/txt.dart';
import 'package:teatally/core/widgets/common_widgets.dart';
import 'package:teatally/core/widgets/form_components.dart';
import 'package:teatally/features/group/application/cubit/group_detail_cubit.dart';
import 'package:teatally/features/group/domain/categories_model.dart';
import 'package:uuid/uuid.dart';

class AddCategoryDialog extends StatelessWidget {
  AddCategoryDialog({
    super.key,
    required this.groupId,
  });
  final String groupId;
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Txt('Add Categories'),
      content: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FormComponents.formBuilderTextField(context,
                fieldName: 'name',
                label: 'Categories Name',
                hintText: 'Enter Categories Name',
                isRequired: true),
            CommonWidgets.coloredTextButton(context, text: 'Save',
                onPressed: () {
              final formState = _formKey.currentState;
              if (formState?.validate() ?? false) {
                final categoryDetail = CategoriesModel(
                    uid: const Uuid().v4(),
                    name: formState?.fields['name']?.value ?? '',
                    groupId: groupId,
                    createdAt: DateTime.now());
                context
                    .read<GroupDetailCubit>()
                    .addCategory(groupId, categoryDetail);
              }
            })
          ],
        ),
      ),
    );
  }
}