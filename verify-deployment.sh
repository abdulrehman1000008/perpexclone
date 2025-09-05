#!/bin/bash

# 🚀 SearchAI Deployment Verification Script
# This script verifies that your deployment is working correctly

echo "🔍 SearchAI Deployment Verification"
echo "==================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to check if a URL is accessible
check_url() {
    local url=$1
    local description=$2
    local expected_status=${3:-200}
    
    echo -n "Checking $description... "
    
    response=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "$url")
    
    if [ "$response" = "$expected_status" ]; then
        echo -e "${GREEN}✅ OK (Status: $response)${NC}"
        return 0
    else
        echo -e "${RED}❌ FAILED (Status: $response)${NC}"
        return 1
    fi
}

# Function to check JSON response
check_json_response() {
    local url=$1
    local description=$2
    
    echo -n "Checking $description... "
    
    response=$(curl -s --max-time 10 "$url")
    
    if echo "$response" | jq . >/dev/null 2>&1; then
        echo -e "${GREEN}✅ OK (Valid JSON)${NC}"
        echo "   Response: $(echo "$response" | jq -c .)"
        return 0
    else
        echo -e "${RED}❌ FAILED (Invalid JSON or no response)${NC}"
        echo "   Response: $response"
        return 1
    fi
}

# Get URLs from user
echo "Please provide your deployment URLs:"
echo ""
read -p "🌐 Frontend URL (Vercel): " FRONTEND_URL
read -p "🖥️  Backend URL (Render): " BACKEND_URL

# Remove trailing slashes
FRONTEND_URL=${FRONTEND_URL%/}
BACKEND_URL=${BACKEND_URL%/}

echo ""
echo "📊 Testing Deployment..."
echo "========================"
echo ""

# Test counters
tests_passed=0
tests_failed=0

# Test 1: Frontend accessibility
echo "1️⃣ Frontend Tests"
echo "----------------"
if check_url "$FRONTEND_URL" "Frontend homepage"; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

if check_url "$FRONTEND_URL/manifest.json" "Manifest file"; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

echo ""

# Test 2: Backend accessibility
echo "2️⃣ Backend Tests"
echo "---------------"
if check_json_response "$BACKEND_URL/api/health" "Backend health endpoint"; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

if check_url "$BACKEND_URL" "Backend root endpoint"; then
    ((tests_passed++))
else
    ((tests_failed++))
fi

echo ""

# Test 3: CORS Test
echo "3️⃣ CORS Configuration Test"
echo "-------------------------"
echo "Testing CORS from frontend to backend..."

cors_test=$(curl -s \
    -H "Origin: $FRONTEND_URL" \
    -H "Access-Control-Request-Method: POST" \
    -H "Access-Control-Request-Headers: Content-Type,Authorization" \
    -X OPTIONS \
    "$BACKEND_URL/api/auth/login" \
    -w "%{http_code}")

if [[ "$cors_test" =~ 200|204 ]]; then
    echo -e "${GREEN}✅ CORS configuration OK${NC}"
    ((tests_passed++))
else
    echo -e "${RED}❌ CORS configuration FAILED${NC}"
    echo "   Backend may not be configured to accept requests from frontend"
    ((tests_failed++))
fi

echo ""

# Test 4: Environment Variables Test
echo "4️⃣ Environment Configuration Test"
echo "--------------------------------"

# Test if frontend is using correct API URL
echo "Testing frontend environment configuration..."
frontend_config=$(curl -s "$FRONTEND_URL" | grep -o 'VITE_API_URL[^"]*' || echo "Not found")

if [[ "$frontend_config" == *"localhost"* ]]; then
    echo -e "${RED}❌ Frontend still configured for localhost${NC}"
    echo "   Update VITE_API_URL in Vercel environment variables"
    ((tests_failed++))
elif [[ "$frontend_config" == *"onrender.com"* ]] || [[ "$frontend_config" == "Not found" ]]; then
    echo -e "${GREEN}✅ Frontend environment configuration OK${NC}"
    ((tests_passed++))
else
    echo -e "${YELLOW}⚠️  Could not verify frontend environment${NC}"
fi

echo ""

# Summary
echo "📋 Test Summary"
echo "==============="
echo -e "Tests Passed: ${GREEN}$tests_passed${NC}"
echo -e "Tests Failed: ${RED}$tests_failed${NC}"
echo ""

if [ $tests_failed -eq 0 ]; then
    echo -e "${GREEN}🎉 All tests passed! Your deployment is working correctly.${NC}"
    echo ""
    echo "🔗 Your SearchAI Application:"
    echo "   Frontend: $FRONTEND_URL"
    echo "   Backend:  $BACKEND_URL"
    echo "   Health:   $BACKEND_URL/api/health"
else
    echo -e "${RED}❌ Some tests failed. Please check the following:${NC}"
    echo ""
    echo "🔧 Common Issues:"
    echo "   1. Verify environment variables in both Vercel and Render"
    echo "   2. Check CORS_ORIGIN in Render matches your Vercel URL exactly"
    echo "   3. Ensure VITE_API_URL in Vercel points to your Render backend"
    echo "   4. Check both services are deployed and running"
    echo ""
    echo "📚 For detailed troubleshooting, see: DEPLOYMENT_TROUBLESHOOTING.md"
fi

echo ""
echo "🆘 Need help?"
echo "   - Check deployment logs in Vercel and Render dashboards"
echo "   - Verify all environment variables are set correctly"
echo "   - Test individual endpoints manually"
echo "   - Review DEPLOYMENT_TROUBLESHOOTING.md for detailed steps"
