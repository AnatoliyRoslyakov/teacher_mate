import 'package:flutter/material.dart';

/// {@template modal_bottom_sheet_wrapper}
/// ModalBottomSheetScaffoldWrapper widget.
/// {@endtemplate}
class ModalBottomSheetScaffoldWrapper extends StatelessWidget {
  /// {@macro modal_bottom_sheet_wrapper}
  const ModalBottomSheetScaffoldWrapper({
    super.key,
    required this.child,
    this.firstIcon,
    this.secondIcon,
    required this.title,
    this.firstOnPressed,
    this.secondOnPressed,
  });
  final Widget child;
  final Widget? firstIcon;
  final Widget? secondIcon;
  final String title;
  final VoidCallback? firstOnPressed;
  final VoidCallback? secondOnPressed;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          children: [
            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 30,
                      height: 4,
                      clipBehavior: Clip.antiAlias,
                      decoration: ShapeDecoration(
                        color: const Color(0xFF989CAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 50),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          if (firstIcon != null)
                            InkWell(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: firstIcon,
                                ),
                              ),
                              onTap: firstOnPressed,
                            )
                          else
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                          const Spacer(),
                          Text(
                            title,
                          ),
                          const Spacer(),
                          if (secondIcon != null)
                            InkWell(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: secondIcon,
                                ),
                              ),
                              onTap: secondOnPressed,
                            )
                          else
                            const SizedBox(
                              width: 50,
                              height: 50,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: child),
          ],
        ),
      );
}
