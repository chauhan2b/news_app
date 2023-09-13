import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArticleLoadingShimmer extends StatelessWidget {
  const ArticleLoadingShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color primaryColor = Theme.of(context).colorScheme.primary;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: primaryColor.withOpacity(0.05),
        highlightColor: primaryColor.withOpacity(0.2),
        child: Column(
          children: [
            Container(
              height: size.height * 0.24,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: 24,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Container(
                  height: 24,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                const Spacer(),
                Container(
                  height: 24,
                  width: 24,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
