/// Modelo de Membresía
/// Representa la activación de un programa por parte de un usuario
class Membership {
  final String id;
  final String userId;
  final String programId;
  final DateTime startDate;
  final DateTime endDate;
  final double paidAmount;
  final String status; // 'active', 'expired', 'pending'
  final String? paymentReferenceId;
  final DateTime createdAt;

  Membership({
    required this.id,
    required this.userId,
    required this.programId,
    required this.startDate,
    required this.endDate,
    required this.paidAmount,
    required this.status,
    this.paymentReferenceId,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Verifica si la membresía está activa
  bool get isActive {
    return status == 'active' && DateTime.now().isBefore(endDate);
  }

  /// Retorna días restantes de la membresía
  int get daysRemaining {
    if (!isActive) return 0;
    return endDate.difference(DateTime.now()).inDays;
  }

  /// Retorna el estado traducido
  String get statusTranslated {
    const translations = {
      'active': 'Activa',
      'expired': 'Expirada',
      'pending': 'Pendiente',
    };
    return translations[status] ?? status;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'paidAmount': paidAmount,
      'status': status,
      'paymentReferenceId': paymentReferenceId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Membership.fromJson(Map<String, dynamic> json) {
    return Membership(
      id: json['id'],
      userId: json['userId'],
      programId: json['programId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      paidAmount: json['paidAmount'].toDouble(),
      status: json['status'],
      paymentReferenceId: json['paymentReferenceId'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  static List<Membership> mockList() {
    return [
      Membership(
        id: 'membership_1',
        userId: '1',
        programId: 'program_1',
        startDate: DateTime.now().subtract(const Duration(days: 15)),
        endDate: DateTime.now().add(const Duration(days: 69)), // 12 semanas
        paidAmount: 49.99,
        status: 'active',
        paymentReferenceId: 'payment_123',
      ),
    ];
  }
}

/// Modelo de Pago
/// Representa un pago realizado por el usuario (adaptado para Venezuela)
class Payment {
  final String id;
  final String userId;
  final String programId;
  final double amount;
  final String currency; // 'USD', 'VES'
  final String method; // 'mobile_payment', 'transfer', 'card'
  final String bank; // Banco emisor
  final String phone; // Teléfono asociado
  final String identificationNumber; // Cédula
  final String referenceNumber; // Número de referencia del pago
  final String status; // 'pending', 'approved', 'rejected'
  final DateTime createdAt;
  final DateTime? processedAt;
  final String? adminNotes;

  Payment({
    required this.id,
    required this.userId,
    required this.programId,
    required this.amount,
    required this.currency,
    required this.method,
    required this.bank,
    required this.phone,
    required this.identificationNumber,
    required this.referenceNumber,
    this.status = 'pending',
    DateTime? createdAt,
    this.processedAt,
    this.adminNotes,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Retorna el estado traducido
  String get statusTranslated {
    const translations = {
      'pending': 'Pendiente',
      'approved': 'Aprobado',
      'rejected': 'Rechazado',
    };
    return translations[status] ?? status;
  }

  /// Retorna el método traducido
  String get methodTranslated {
    const translations = {
      'mobile_payment': 'Pago Móvil',
      'transfer': 'Transferencia',
      'card': 'Tarjeta',
    };
    return translations[method] ?? method;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'programId': programId,
      'amount': amount,
      'currency': currency,
      'method': method,
      'bank': bank,
      'phone': phone,
      'identificationNumber': identificationNumber,
      'referenceNumber': referenceNumber,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'processedAt': processedAt?.toIso8601String(),
      'adminNotes': adminNotes,
    };
  }

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      userId: json['userId'],
      programId: json['programId'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      method: json['method'],
      bank: json['bank'],
      phone: json['phone'],
      identificationNumber: json['identificationNumber'],
      referenceNumber: json['referenceNumber'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
      processedAt: json['processedAt'] != null 
          ? DateTime.parse(json['processedAt']) 
          : null,
      adminNotes: json['adminNotes'],
    );
  }

  static List<Payment> mockList() {
    return [
      Payment(
        id: 'payment_1',
        userId: '1',
        programId: 'program_1',
        amount: 49.99,
        currency: 'USD',
        method: 'mobile_payment',
        bank: 'Banco de Venezuela',
        phone: '0412-1234567',
        identificationNumber: 'V-12345678',
        referenceNumber: '2024110212345678',
        status: 'approved',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        processedAt: DateTime.now().subtract(const Duration(days: 14)),
      ),
      Payment(
        id: 'payment_2',
        userId: '2',
        programId: 'program_2',
        amount: 39.99,
        currency: 'USD',
        method: 'mobile_payment',
        bank: 'Banesco',
        phone: '0414-9876543',
        identificationNumber: 'V-98765432',
        referenceNumber: '2024110198765432',
        status: 'pending',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }
}
