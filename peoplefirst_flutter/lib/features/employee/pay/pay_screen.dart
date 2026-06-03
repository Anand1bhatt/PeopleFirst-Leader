import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/pf_card.dart';
import '../../../shared/widgets/pf_button.dart';

class PayScreen extends StatelessWidget {
  const PayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceSubtle,
      appBar: AppBar(
        title: const Text(
          'Pay',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.contentHeavy,
          ),
        ),
        backgroundColor: AppColors.surfaceMinimal,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // CTC summary
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.relianceBase, Color(0xFF2547C7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Annual CTC',
                  style: TextStyle(
                    color: Color(0xCCFFFFFF),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '₹28,50,000',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _PayChip(label: 'Fixed', value: '₹22.5L'),
                    const SizedBox(width: 8),
                    _PayChip(label: 'Variable', value: '₹5.5L'),
                    const SizedBox(width: 8),
                    _PayChip(label: 'Benefits', value: '₹0.5L'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Latest payslip
          PfCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'May 2025 Payslip',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.contentHeavy,
                        ),
                      ),
                    ),
                    PfButton(
                      label: 'Download',
                      onPressed: () {},
                      variant: PfButtonVariant.secondary,
                      compact: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _PayRow(label: 'Basic', amount: '₹1,12,500', isPositive: true),
                _PayRow(label: 'HRA', amount: '₹45,000', isPositive: true),
                _PayRow(
                    label: 'Special Allowance',
                    amount: '₹30,000',
                    isPositive: true),
                const Divider(height: 16),
                _PayRow(label: 'Gross', amount: '₹1,87,500', isPositive: true, isBold: true),
                _PayRow(
                    label: 'PF Deduction',
                    amount: '₹13,500',
                    isPositive: false),
                _PayRow(
                    label: 'Professional Tax',
                    amount: '₹200',
                    isPositive: false),
                _PayRow(
                    label: 'Income Tax (TDS)',
                    amount: '₹18,750',
                    isPositive: false),
                const Divider(height: 16),
                _PayRow(
                  label: 'Net Pay',
                  amount: '₹1,55,050',
                  isPositive: true,
                  isBold: true,
                  highlight: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Text('PAST PAYSLIPS', style: AppTextStyles.sectionHeader),
          const SizedBox(height: 10),

          PfCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                _SlipRow(month: 'April 2025', netPay: '₹1,55,050'),
                const Divider(height: 1),
                _SlipRow(month: 'March 2025', netPay: '₹1,55,050'),
                const Divider(height: 1),
                _SlipRow(month: 'February 2025', netPay: '₹1,52,050'),
                const Divider(height: 1),
                _SlipRow(month: 'January 2025', netPay: '₹1,52,050'),
              ],
            ),
          ),

          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _PayChip extends StatelessWidget {
  final String label;
  final String value;

  const _PayChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xCCFFFFFF),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _PayRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isPositive;
  final bool isBold;
  final bool highlight;

  const _PayRow({
    required this.label,
    required this.amount,
    required this.isPositive,
    this.isBold = false,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
                color: highlight
                    ? AppColors.relianceBase
                    : AppColors.contentHeavy,
              ),
            ),
          ),
          Text(
            isPositive ? amount : '- $amount',
            style: TextStyle(
              fontSize: 13,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: highlight
                  ? AppColors.relianceBase
                  : isPositive
                      ? AppColors.contentHeavy
                      : AppColors.negative,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlipRow extends StatelessWidget {
  final String month;
  final String netPay;

  const _SlipRow({required this.month, required this.netPay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Icon(
            Icons.description_outlined,
            size: 18,
            color: AppColors.relianceBase,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(month, style: AppTextStyles.body.copyWith(fontSize: 13)),
          ),
          Text(
            netPay,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.contentHeavy,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.download_rounded,
            size: 16,
            color: AppColors.contentMinimal,
          ),
        ],
      ),
    );
  }
}
