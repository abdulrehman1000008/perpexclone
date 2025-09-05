import { Navigate } from 'react-router-dom';
import authStore from '../stores/authStore';

const ProtectedRoute = ({ children }) => {
  const { isAuthenticated, loading } = authStore((state) => state); // ✅ FIXED: Use proper Zustand selector pattern

  // Show loading state while checking authentication
  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  // Redirect to login if not authenticated
  if (!isAuthenticated) {
    return <Navigate to="/login" replace />;
  }

  // Render children if authenticated
  return children;
};

export default ProtectedRoute;
