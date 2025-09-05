@echo off
REM 🚨 IMMEDIATE FIX for perpexclone deployment errors

echo 🚨 IMMEDIATE FIX for SearchAI Deployment
echo ========================================
echo.

REM Your specific URLs
set FRONTEND_URL=https://perpexclone-halehngwf.vercel.app
set BACKEND_URL=https://perpexclone.onrender.com

echo 🎯 Target URLs:
echo Frontend: %FRONTEND_URL%
echo Backend:  %BACKEND_URL%
echo.

echo 🔧 CRITICAL FIXES NEEDED:
echo =========================
echo.

echo 1️⃣ VERCEL ENVIRONMENT VARIABLES (URGENT)
echo ----------------------------------------
echo Go to: https://vercel.com/dashboard
echo → Select your 'perpexclone' project
echo → Settings → Environment Variables
echo → Add these variables for PRODUCTION environment:
echo.
echo VITE_API_URL = https://perpexclone.onrender.com/api
echo VITE_APP_NAME = AI Search
echo VITE_APP_VERSION = 1.0.0
echo VITE_NODE_ENV = production
echo.
echo ⚠️  IMPORTANT: Set Environment to 'Production' for each variable
echo.

echo 2️⃣ RENDER ENVIRONMENT VARIABLES (CRITICAL)
echo -------------------------------------------
echo Go to: https://dashboard.render.com
echo → Select your backend service
echo → Environment tab
echo → Update this variable:
echo.
echo CORS_ORIGIN = https://perpexclone-halehngwf.vercel.app
echo.
echo ⚠️  CRITICAL: Must match your Vercel URL EXACTLY
echo.

echo 3️⃣ IMMEDIATE DEPLOYMENT ACTIONS
echo -------------------------------
echo After updating environment variables:
echo.
echo A. Redeploy Vercel:
echo    → Go to Vercel Dashboard → Deployments
echo    → Click 'Redeploy' on the latest deployment
echo.
echo B. Redeploy Render:
echo    → Go to Render Dashboard → Your Service
echo    → Click 'Manual Deploy' → 'Deploy latest commit'
echo.

echo 4️⃣ TEST YOUR DEPLOYMENT
echo -----------------------
echo After both services redeploy, test these URLs:
echo.
echo ✅ Frontend: %FRONTEND_URL%
echo ✅ Manifest: %FRONTEND_URL%/manifest.json
echo ✅ Backend Health: %BACKEND_URL%/api/health
echo.

echo 🚨 QUICK TESTS TO RUN:
echo ======================
echo.
echo Test 1 - Check if backend is accessible:
echo curl -s %BACKEND_URL%/api/health
echo.
echo Test 2 - Check CORS configuration:
echo curl -s -X OPTIONS -H "Origin: %FRONTEND_URL%" %BACKEND_URL%/api/auth/login
echo.
echo Test 3 - Check manifest file:
echo curl -s %FRONTEND_URL%/manifest.json
echo.

echo 🎯 EXPECTED RESULTS AFTER FIX:
echo ===============================
echo ✅ No 401 errors for manifest.json
echo ✅ No CORS errors in browser console
echo ✅ API calls work from frontend to backend
echo ✅ User registration/login works
echo.

echo 🆘 IF ISSUES PERSIST:
echo =====================
echo 1. Clear browser cache (Ctrl+Shift+R)
echo 2. Check environment variables are set correctly
echo 3. Verify both services have redeployed successfully
echo 4. Check logs in both Vercel and Render dashboards
echo.

echo 📞 Need more help? Check DEPLOYMENT_TROUBLESHOOTING.md for detailed steps.
echo.

pause
