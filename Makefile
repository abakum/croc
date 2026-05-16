# Makefile для замены подмодуля
.PHONY: subm

# Переменные
INTERNAL_DIR := internal
REPO_URL := https://github.com/abakCroc/croc.git
BRANCH := main

# Полная замена подмодуля
subm:
	@echo "Замена подмодуля '$(INTERNAL_DIR)' на $(REPO_URL)"
	git submodule deinit -f $(INTERNAL_DIR) 2>/dev/null || true
	git rm -f $(INTERNAL_DIR) 2>/dev/null || true
	rm -rf .git/modules/$(INTERNAL_DIR)
	git submodule add -b $(BRANCH) $(REPO_URL) $(INTERNAL_DIR)
	@echo "Добавление $(INTERNAL_DIR) в .gitignore..."
	@touch .gitignore
	@if ! grep -qxF "$(INTERNAL_DIR)/" .gitignore && ! grep -qxF "$(INTERNAL_DIR)" .gitignore; then \
		echo "$(INTERNAL_DIR)/" >> .gitignore; \
		echo "✅ $(INTERNAL_DIR)/ добавлен в .gitignore"; \
	else \
		echo "ℹ️  $(INTERNAL_DIR) уже есть в .gitignore"; \
	fi
	git add .gitmodules $(INTERNAL_DIR) .gitignore
	git commit -m "Replace internal repo with $(REPO_URL)" || echo "Nothing to commit"
	@echo "✅ Готово!"