@echo off
REM 🚀 SearchAI Deployment Verification Script (Windows)
REM This script verifies that your deployment is working correctly

echo 🔍 SearchAI Deployment Verification
echo ===================================
echo.

set /p FRONTEND_URL="🌐 Enter your Frontend URL (Vercel): "
set /p BACKEND_URL="🖥️  Enter your Backend URL (Render): "

REM Remove trailing slashes
if "%FRONTEND_URL:~-1%"=="/" set FRONTEND_URL=%FRONTEND_URL:~0,-1%
if "%BACKEND_URL:~-1%"=="/" set BACKEND_URL=%BACKEND_URL:~0,-1%

echo.
echo 📊 Testing Deployment...
echo ========================
echo.

set tests_passed=0
set tests_failed=0

REM Test 1: Frontend accessibility
echo 1️⃣ Frontend Tests
echo ----------------

REM Check frontend homepage
echo Checking Frontend homepage...
curl -s -o nul -w "%%{http_code}" %FRONTEND_URL% | findstr "200" >nul
if %errorlevel%==0 (
    echo ✅ Frontend homepage OK
    set /a tests_passed+=1
) else (
    echo ❌ Frontend homepage FAILED
    set /a tests_failed+=1
)

REM Check manifest.json
echo Checking Manifest file...
curl -s -o nul -w "%%{http_code}" %FRONTEND_URL%/manifest.json | findstr "200" >nul
if %errorlevel%==0 (
    echo ✅ Manifest file OK
    set /a tests_passed+=1
) else (
    echo ❌ Manifest file FAILED
    set /a tests_failed+=1
)

echo.

REM Test 2: Backend accessibility
echo 2️⃣ Backend Tests
echo ---------------

REM Check backend health
echo Checking Backend health endpoint...
curl -s %BACKEND_URL%/api/health | findstr "status" >nul
if %errorlevel%==0 (
    echo ✅ Backend health endpoint OK
    set /a tests_passed+=1
) else (
    echo ❌ Backend health endpoint FAILED
    set /a tests_failed+=1
)

REM Check backend root
echo Checking Backend root endpoint...
curl -s -o nul -w "%%{http_code}" %BACKEND_URL% | findstr "200" >nul
if %errorlevel%==0 (
    echo ✅ Backend root endpoint OK
    set /a tests_passed+=1
) else (
    echo ❌ Backend root endpoint FAILED
    set /a tests_failed+=1
)

echo.

REM Test 3: CORS Test
echo 3️⃣ CORS Configuration Test
echo -------------------------
echo Testing CORS from frontend to backend...

curl -s -X OPTIONS -H "Origin: %FRONTEND_URL%" -H "Access-Control-Request-Method: POST" -o nul -w "%%{http_code}" %BACKEND_URL%/api/auth/login | findstr /R "200 204" >nul
if %errorlevel%==0 (
    echo ✅ CORS configuration OK
    set /a tests_passed+=1
) else (
    echo ❌ CORS configuration FAILED
    echo    Backend may not be configured to accept requests from frontend
    set /a tests_failed+=1
)

echo.

REM Summary
echo 📋 Test Summary
echo ===============
echo Tests Passed: %tests_passed%
echo Tests Failed: %tests_failed%
echo.

if %tests_failed%==0 (
    echo 🎉 All tests passed! Your deployment is working correctly.
    echo.
    echo 🔗 Your SearchAI Application:
    echo    Frontend: %FRONTEND_URL%
    echo    Backend:  %BACKEND_URL%
    echo    Health:   %BACKEND_URL%/api/health
) else (
    echo ❌ Some tests failed. Please check the following:
    echo.
    echo 🔧 Common Issues:
    echo    1. Verify environment variables in both Vercel and Render
    echo    2. Check CORS_ORIGIN in Render matches your Vercel URL exactly
    echo    3. Ensure VITE_API_URL in Vercel points to your Render backend
    echo    4. Check both services are deployed and running
    echo.
    echo 📚 For detailed troubleshooting, see: DEPLOYMENT_TROUBLESHOOTING.md
)

echo.
echo 🆘 Need help?
echo    - Check deployment logs in Vercel and Render dashboards
echo    - Verify all environment variables are set correctly
echo    - Test individual endpoints manually
echo    - Review DEPLOYMENT_TROUBLESHOOTING.md for detailed steps

pause
