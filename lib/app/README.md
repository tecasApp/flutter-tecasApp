### **Basic Explanation of the `app` Module**  

To better understand the application's structure, this module is divided into three key components:  

1. **Authentication System**  
2. **`AppView`**  
3. **`AppProvider`**  

#### **🔹 `AppProvider`**  
The `AppProvider` class is responsible for **dependency injection** and managing **global states** within the application context. Its main function is to verify and store user information by triggering an event that checks the cached instance. Based on the authentication status, the user is then redirected accordingly.  

#### **🔹 `AppView`**  
The `AppView` serves as the core structure of the application. In addition to defining the **visual theme**, it integrates `GoRouter`, which manages the app’s navigation system.  

#### **🔹 Authentication System**  
The authentication system consists of various login strategies, separating external authentication logic (**services**) from its internal use within the application (**repositories**). Currently, the supported authentication methods are:  
- Google  
- Email and password  
- Phone number  

This structure ensures better scalability and maintainability of the authentication system. 🚀