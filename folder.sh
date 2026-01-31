#!/bin/bash

# ---------- CREATE FOLDERS ----------

# Base
mkdir -p lib/{app,core,features,l10n}

# App
mkdir -p lib/app/{routes,theme}

# Core
mkdir -p lib/core/{api,config,constants,error,extensions,providers,services,usecases,utils,widgets}

# Features
FEATURES=(user dashboard profile auth)

for feature in "${FEATURES[@]}"; do
  mkdir -p lib/features/$feature/data/{datasources,models,repositories,schemas}
  mkdir -p lib/features/$feature/domain/{entities,repositories,usecases}
  mkdir -p lib/features/$feature/presentation/{pages,providers,state,view_models,widgets}
done

# ---------- ADD .gitignore TO EMPTY DIRECTORIES ----------

find lib -type d | while read -r dir; do
  # Check if directory is empty
  if [ -z "$(ls -A "$dir")" ]; then
    # Create .gitignore only if it doesn't exist
    if [ ! -f "$dir/.gitignore" ]; then
      echo "*" > "$dir/.gitignore"
      echo "!.gitignore" >> "$dir/.gitignore"
    fi
  fi
done

echo "Folder structure created and empty folders protected for Git."
