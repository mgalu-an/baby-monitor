#!/bin/bash

# 🚀 Baby Monitor - Skrypt do szybkiej aktualizacji
# Użycie: ./deploy.sh "opis zmian"

# Kolory dla ładniejszego wyświetlania
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Baby Monitor - Deployment${NC}"
echo ""

# Sprawdź czy jesteś w dobrym folderze
if [ ! -f "index.html" ]; then
    echo -e "${RED}❌ Błąd: Nie znaleziono pliku index.html${NC}"
    echo "Upewnij się, że jesteś w folderze baby-monitor"
    exit 1
fi

# Pobierz opis zmian z argumentu lub użyj domyślnego
COMMIT_MESSAGE="${1:-Aktualizacja aplikacji}"

echo -e "${BLUE}📦 Dodawanie zmian...${NC}"
git add .

echo -e "${BLUE}💾 Zapisywanie: ${COMMIT_MESSAGE}${NC}"
git commit -m "$COMMIT_MESSAGE"

echo -e "${BLUE}☁️  Wysyłanie na GitHub...${NC}"
git push

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Sukces! Aplikacja została zaktualizowana!${NC}"
    echo -e "${GREEN}Zmiany będą widoczne za 1-2 minuty na GitHub Pages${NC}"
    echo ""
    echo "🌐 Twoja aplikacja: https://$(git config --get remote.origin.url | sed 's/.*github.com[:/]\(.*\)\.git/\1.github.io/' | sed 's/\//\//' | sed 's/$/\//')"
else
    echo ""
    echo -e "${RED}❌ Wystąpił błąd podczas wysyłania na GitHub${NC}"
    echo "Sprawdź powyższe komunikaty lub uruchom 'git status'"
fi
