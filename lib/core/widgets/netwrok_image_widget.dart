import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medical_devices_app/core/utils/app_size_extension.dart';

class NetworkCustomImageWidget extends StatelessWidget {
  const NetworkCustomImageWidget({
    required this.imageUrl,
    required this.height,
    this.background = false,
    this.isSvg = false,
    this.fit = BoxFit.fill,
    this.width,
    super.key,
  });

  final String imageUrl;
  final double height;
  final bool background;
  final bool isSvg;
  final BoxFit fit;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final isLocalAsset = imageUrl.startsWith('assets/');
    final resolvedHeight = _resolveHeight(context);

    return RepaintBoundary(
      child: SizedBox(
        height: resolvedHeight,
        width: width,
        child: isLocalAsset ? _assetImage(context) : _remoteImage(context),
      ),
    );
  }

  double? _resolveHeight(BuildContext context) {
    return height.isFinite ? context.height(height) : null;
  }

  Widget _assetImage(BuildContext context) {
    return Image.asset(
      imageUrl,
      fit: fit,
      width: width ?? double.infinity,
      height: _resolveHeight(context),
      filterQuality: FilterQuality.medium,
      gaplessPlayback: true,
      errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.medical_services_outlined, size: 42),
    );
  }

  Widget _remoteImage(BuildContext context) {
    final resolvedHeight = _resolveHeight(context);

    if (isSvg) {
      return Center(
        child: SvgPicture.network(
          imageUrl,
          placeholderBuilder: (BuildContext context) =>
              _ImageLoadingBox(height: resolvedHeight, background: background),
          height: resolvedHeight,
          fit: fit,
        ),
      );
    }

    return CachedNetworkImage(
      alignment: Alignment.center,
      imageUrl: imageUrl,
      fit: fit,
      width: double.infinity,
      height: resolvedHeight,
      placeholder: (context, url) => _ImageLoadingBox(
        height: resolvedHeight == null ? null : resolvedHeight / 3,
        background: background,
      ),
      errorWidget: (context, url, error) =>
          const Icon(Icons.medical_services_outlined, size: 42),
    );
  }
}

class _ImageLoadingBox extends StatelessWidget {
  const _ImageLoadingBox({required this.height, required this.background});

  final double? height;
  final bool background;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      color: background ? Colors.grey.shade200 : null,
      child: const SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(strokeWidth: 2.2),
      ),
    );
  }
}
