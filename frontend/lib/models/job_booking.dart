/**
 * Job Booking Model
 * 
 * Represents a job booking/appointment in the StyleHer app.
 * Contains booking information including client details, service type, and scheduling.
 * Used for storing and retrieving job bookings from Firestore.
 */
class JobBooking {
/**
   * Booking unique identifier
   */
  final String id;

  /**
   * Client's full name
   */
  final String clientName;

  /**
   * Client's phone number
   */
  final String clientPhone;

  /**
   * Client's email address
   */
  final String clientEmail;

  /**
   * Type of beauty service requested
   */
  final String serviceType;

  /**
   * Preferred appointment date
   */
  final String preferredDate;

  /**
   * Preferred appointment time
   */
  final String preferredTime;

  /**
   * Appointment location
   */
  final String location;

  /**
   * Assigned stylist ID (optional)
   */
  final String? stylistId;

  /**
   * Booking status: pending, accepted, rejected, completed
   */
  final String status;

  /**
   * Additional booking notes (optional)
   */
  final String? notes;

  /**
   * Booking creation timestamp
   */
  final DateTime createdAt;

  /**
   * Booking last update timestamp
   */
  final DateTime updatedAt;

  JobBooking({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    required this.clientEmail,
    required this.serviceType,
    required this.preferredDate,
    required this.preferredTime,
    required this.location,
    this.stylistId,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

/**
   * Create JobBooking from Firestore document data
   * 
   * @param id Document ID
   * @param data Document data map
   * @return JobBooking instance
   */
  factory JobBooking.fromMap(String id, Map<String, dynamic> data) {
    return JobBooking(
      id: id,
      clientName: data['clientName'] ?? '',
      clientPhone: data['clientPhone'] ?? '',
      clientEmail: data['clientEmail'] ?? '',
      serviceType: data['serviceType'] ?? '',
      preferredDate: data['preferredDate'] ?? '',
      preferredTime: data['preferredTime'] ?? '',
      location: data['location'] ?? '',
      stylistId: data['stylistId'],
      status: data['status'] ?? 'pending',
      notes: data['notes'],
      createdAt: (data['createdAt'] as DateTime?) ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as DateTime?) ?? DateTime.now(),
    );
  }

/**
   * Convert JobBooking to Firestore document data
   * 
   * @return Map of booking properties for Firestore
   */
  Map<String, dynamic> toMap() {
    return {
      'clientName': clientName,
      'clientPhone': clientPhone,
      'clientEmail': clientEmail,
      'serviceType': serviceType,
      'preferredDate': preferredDate,
      'preferredTime': preferredTime,
      'location': location,
      'stylistId': stylistId,
      'status': status,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}