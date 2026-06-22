@echo off
echo Starting backend...
cd backend
call venv\Scripts\activate
start uvicorn main:app --reload

echo Starting Flutter app...
cd ..
cd flipmark
flutter run
