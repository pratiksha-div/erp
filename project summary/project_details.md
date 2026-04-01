# **PROJECT DOCUMENTATION: BuildTrack ERP**

## **1. TITLE PAGE**

**Project Name:** BuildTrack ERP  
**Document Type:** Project Specification & Technical Documentation  
**Version:** 1.0  
**Technology Stack:** Flutter, BLoC Architecture, RESTful APIs  

---

## **2. EXECUTIVE SUMMARY**
This project is an advanced Enterprise Resource Planning (ERP) mobile application specifically designed for the construction and project management industry. The primary goal is to digitize on-site operations, replacing manual paper-based logs with a real-time, synchronized digital platform. By integrating material tracking, machinery monitoring, and daily labor reporting, the system ensures high data integrity and operational transparency for stakeholders at all levels.

---

## **3. PROJECT OVERVIEW**
The BuildTrack ERP provides a centralized dashboard for managing diverse construction activities. It bridges the gap between field operations and administrative oversight. The application focuses on high-frequency field data points such as material movement (Gate Pass), vehicle utilization (Vehicle Gate Pass), and daily progress (Daily Reporting), providing a "single source of truth" for project status.

---

## **4. OBJECTIVES**
*   **Real-time Visibility:** Provide project managers with live updates from the field.
*   **Role-Based Access:** Implement strict data visibility rules based on user roles (Admin, Coordinator, Sub-Coordinator).
*   **Data Accuracy:** Reduce human error in unit conversions and stock balances through automated calculation logic.
*   **Digital Audit Trail:** Maintain a permanent, searchable record of all material and vehicle movements.

---

## **5. SCOPE**

### **In-Scope**
*   Digital Gate Pass generation for materials and vehicles.
*   Machinery utilization and "Total Run" tracking.
*   Daily work reporting and material consumption logs.
*   Goods Received Note (GRN) verification.
*   Role-specific dynamic user interfaces.

### **Out-of-Scope**
*   Full-scale financial accounting and payroll management.
*   Offline data synchronization (Requires active internet connection).
*   Integrated BIM (Building Information Modeling) 3D viewing.

---

## **6. SYSTEM ARCHITECTURE / DESIGN**
The application follows a **Modular Clean Architecture** approach:
*   **UI Layer:** Developed using Flutter, utilizing a custom "Section-Based" design system for consistency.
*   **State Management:** BLoC (Business Logic Component) separates the UI from business rules, ensuring predictable state transitions.
*   **Data Layer:** Utilizes the Repository pattern to handle API communication via HTTP/Dio.
*   **Logic Layer:** Implements complex algorithms for unit conversions (Basic to Alt units) and remaining balance calculations.

---

## **7. TECHNOLOGY STACK**
| Component | Technology |
| :--- | :--- |
| **Frontend Framework** | Flutter (Dart) |
| **State Management** | BLoC / MultiBlocProvider |
| **Networking** | REST APIs (JSON) |
| **Local Storage** | Shared Preferences (Auth & Local Config) |
| **UI Design** | Custom Modular Widgets, Google Fonts, Sizer |
| **Formatting** | Intl (Date/Time/Currency) |

---

## **8. MODULE BREAKDOWN**

### **A. Dashboard & Navigation**
The central hub that dynamically displays modules based on user permissions. It utilizes a standardized grid layout for quick access to core functions.

### **B. Gate Pass Control**
Manages the movement of goods and vehicles.
*   **Material Gate Pass:** Tracks "From" and "To" locations, quantity issued, and remaining stock.
*   **Vehicle Gate Pass:** Logs vehicle entry/exit with gate pass numbering.

### **C. Daily Reporting**
Allows field staff to log progress.
*   **Material Consumption:** Tracks what was used on-site versus what was issued.
*   **Work Details:** Logs specific daily tasks completed by sub-coordinators.

### **D. Vehicle & Machinery Tracking**
Logs machine "Start" and "Stop" readings. It calculates total running time and "Expenditure" automatically to monitor fuel and efficiency.

---

## **9. FEATURES & FUNCTIONALITIES**
*   **Dynamic UI Sections:** Headers and cards change based on user roles (e.g., Sub-Coordinators see specific task logs; Managers see consumption reports).
*   **Unit Conversion Engine:** Handles complex basic-to-alternate unit conversions during material issuance.
*   **Automated Calculations:** Real-time calculation of "Remaining Balance" and "Total Run" to prevent over-allocation.
*   **Validation System:** Multi-tier validation prevents the submission of incomplete gate passes or incorrect readings.

---

## **10. WORKFLOW / PROCESS FLOW**
1.  **Authentication:** User logs in; roles and permissions are fetched.
2.  **Gate Entry:** Materials arrive on-site and are logged.
3.  **GRN Verification:** Manager verifies the quantity and quality of received goods.
4.  **Issuance (Gate Pass):** Materials are moved from the warehouse to specific project zones.
5.  **Consumption:** Daily reporting logs how much of the issued material was actually consumed.
6.  **Reporting:** Admins view aggregated data to determine project efficiency.

---

## **11. UI/UX DESCRIPTION**
The interface focuses on **High-Contrast Clarity** for outdoor use:
*   **Modular Section Cards:** Unified containers with subtle shadows and 22px rounded corners for a modern, consistent look.
*   **Blinking Status Indicators:** Active items with missing data (e.g., missing end-readings) utilize animated blinking effects to alert users.
*   **Role-Dynamic Layouts:** Screens automatically strip away unused buttons or cards based on the user's role to reduce cognitive load.

---

## **12. CHALLENGES FACED & SOLUTIONS**
*   **Challenge:** Redundant API calls when submitting multiple material entries.
    *   *Solution:* Implemented a consolidated CSV-based data aggregation logic to send all entries in a single request.
*   **Challenge:** Maintaining UI consistency across different modules.
    *   *Solution:* Developed a reusable `ModuleSectionCard` widget to standardize section headers and containers.
*   **Challenge:** Accurate unit conversions for diverse material types.
    *   *Solution:* Built a custom conversion factor method within the `MaterialLine` model.

---

## **13. TESTING & VALIDATION**
*   **Unit Testing:** Validation of the conversion engine and balance calculations.
*   **UI Testing:** Verification of role-based visibility across different user accounts.
*   **API Validation:** Ensuring all mandatory fields are caught by the frontend before reaching the server.

---

## **14. FUTURE ENHANCEMENTS**
*   **Offline Mode:** Implementation of a local SQLite database for data entry in zero-connectivity zones.
*   **Image Uploads:** Attaching photos of physical gate passes or machine readings for extra verification.
*   **Push Notifications:** Alerts for managers when material stock falls below a specific threshold.

---

## **15. CONCLUSION**
The BuildTrack ERP represents a significant advancement in project monitoring. By consolidating fragmented field data into a structured, role-aware mobile application, the organization can achieve higher efficiency, reduce material wastage, and maintain precise control over machinery utilization. The modular design ensures the system is ready for future scaling and feature expansion.
