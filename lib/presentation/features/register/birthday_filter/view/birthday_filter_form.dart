import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:tecas_app/app/state/app_bloc.dart';
import 'package:tecas_app/presentation/features/register/birthday_filter/state/birthday_filter_bloc.dart';
import 'package:tecas_app/presentation/features/register/state/register_flow_bloc.dart';

class BirthdayFilterForm extends StatelessWidget {
  const BirthdayFilterForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<BirthdayFilterBloc, BirthdayFilterState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Birthday submitted successfully!')),
          );

          context.read<AppBloc>().add(AppProfileRefreshRequested());
          Future.delayed(const Duration(milliseconds: 300), () {
            context.read<RegisterFlowBloc>().add(GoToNextStep());
          });
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Invalid birthday')),
            );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          _DayInput(),
          SizedBox(height: 8),
          _MonthInput(),
          SizedBox(height: 8),
          _YearInput(),
          SizedBox(height: 16),
          _SubmitButton(),
        ],
      ),
    );
  }
}

class _DayInput extends StatelessWidget {
  const _DayInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (BirthdayFilterBloc bloc) => bloc.state.day.displayError,
    );

    return TextField(
      key: const Key('birthday_day_textfield'),
      onChanged:
          (value) => context.read<BirthdayFilterBloc>().add(DayChanged(value)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Day',
        errorText: displayError != null ? 'Invalid day' : null,
      ),
    );
  }
}

class _MonthInput extends StatelessWidget {
  const _MonthInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (BirthdayFilterBloc bloc) => bloc.state.month.displayError,
    );

    return TextField(
      key: const Key('birthday_month_textfield'),
      onChanged:
          (value) =>
              context.read<BirthdayFilterBloc>().add(MonthChanged(value)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Month',
        errorText: displayError != null ? 'Invalid month' : null,
      ),
    );
  }
}

class _YearInput extends StatelessWidget {
  const _YearInput();

  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (BirthdayFilterBloc bloc) => bloc.state.year.displayError,
    );

    return TextField(
      key: const Key('birthday_year_textfield'),
      onChanged:
          (value) => context.read<BirthdayFilterBloc>().add(YearChanged(value)),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Year',
        errorText: displayError != null ? 'Invalid year' : null,
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.select(
      (BirthdayFilterBloc bloc) => bloc.state.status.isInProgress,
    );

    final isValid = context.select(
      (BirthdayFilterBloc bloc) => bloc.state.isValid,
    );

    if (isSubmitting) {
      return const CircularProgressIndicator();
    }

    return ElevatedButton(
      key: const Key('birthday_submit_button'),
      onPressed:
          isValid
              ? () =>
                  context.read<BirthdayFilterBloc>().add(BirthdaySubmitted())
              : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text('CONTINUE'),
    );
  }
}
