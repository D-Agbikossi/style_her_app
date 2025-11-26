class CloudinaryConfig {
  // Replace these with your actual Cloudinary credentials
  static const String cloudName = 'dicxbs94z';
  static const String apiKey = '332362939222334';
  static const String apiSecret = ''; // Not needed for unsigned uploads
  
  // Optional: Upload preset for unsigned uploads (recommended)
  // If using unsigned uploads, you don't need apiSecret
  static const String uploadPreset = 'style_her_app';
  
  // Whether to use unsigned uploads (recommended for client-side)
  static const bool useUnsignedUpload = true;
}

