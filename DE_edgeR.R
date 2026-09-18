# ==============================================================================
# АНАЛИЗ ДИФФЕРЕНЦИАЛЬНОЙ ЭКСПРЕССИИ ГЕНОВ С УЧЕТОМ БАТЧ-ЭФФЕКТА В EDGER
# ==============================================================================

library(edgeR)

# Установка рабочей директории
base_dir <- "Desktop/trascriptome"

# Загрузка матрицы сырых чтений (raw counts)
data <- read.table(file.path(base_dir, "raw_DGE.txt"),
                   header = TRUE, sep = "\t", row.names = NULL,
                   stringsAsFactors = FALSE)

# Загрузка файла с описанием клинических и технических параметров образцов
Description <- read.table(file.path(base_dir, "Description.txt"),
                          header = TRUE, sep = "\t", row.names = NULL,
                          stringsAsFactors = FALSE)

# Выделяем только столбцы с подсчетами ридов (начиная с 4-й колонки)
counts_matrix <- data[, 4:ncol(data)]
rownames(counts_matrix) <- data$ID

# Сохраняем первые 3 колонки как аннотацию генов (уникальные ID, имена, типы)
gene_annotation <- data[, 1:3]

# Сортируем колонки матрицы в точном соответствии с порядком ID в Description
counts_matrix <- counts_matrix[, Description$ID]

# Критическая проверка: совпадает ли порядок образцов
if (!all(colnames(counts_matrix) == Description$ID)) {
  stop("КРИТИЧЕСКАЯ ОШИБКА: несовпадение имён образцов! Проверьте файлы данных.")
}

# Аннотирование батч-эффекта (группировка образцов по сессиям секвенирования)
batch2_ids <- c("ID7876", "ID7910", "ID8044", "ID8260", "ID8261", "ID8294", "ID8356")
Description$Batch <- ifelse(Description$ID %in% batch2_ids, "Batch2", "Batch1")

# Перевод технических и биологических переменных в факторы (категории)
Description$Batch <- as.factor(Description$Batch)
Description$Batch <- relevel(Description$Batch, ref = "Batch1") # Батч 1 как контроль сравнения

group <- as.factor(Description$Type)
batch <- as.factor(Description$Batch)

# Объединение матрицы чтений, биологических групп и аннотации в единый объект edgeR
dge <- DGEList(counts = counts_matrix, group = group, genes = gene_annotation)

# Создание предварительной матрицы дизайна исключительно для корректной фильтрации
design_filter <- model.matrix(~ batch + group)

# Эффективное удаление шума (низкоэкспрессирующихся генов во всех образцах)
keep <- filterByExpr(dge, design = design_filter)
dge <- dge[keep, , keep.lib.sizes = FALSE]

# Расчет масштабирующих факторов нормализации для выравнивания объемов секвенирования
dge <- calcNormFactors(dge)

# Построение финальной матрицы дизайна: переменная batch идет первой для её блокировки
design <- model.matrix(~ batch + group)
rownames(design) <- colnames(dge)

# Оценка общей, трендовой и гено-специфичной дисперсии с учетом батч-структуры
dge <- estimateDisp(dge, design)

# Фитирование (обучение) модели квази-правдоподобия (квази-информационный критерий)
fit <- glmQLFit(dge, design)

# Проведение теста. Тестируется последний коэффициент (группа сравнения), очищенный от батча
qlf <- glmQLFTest(fit, coef = ncol(design))

# Экстракция полной таблицы результатов без обрезки по P-value (n = Inf)
results <- topTags(qlf, n = Inf, sort.by = "PValue")$table

# Вывод краткой сводки о числе значимо изменяющихся UP/DOWN генов при FDR < 0.05
cat("\n--- Сводка значимых генов (FDR < 0.05) ---\n")
print(summary(decideTests(qlf, p.value = 0.05, adjust.method = "BH")))

# Сохранение результатов в текстовый файл с табуляцией
write.table(results, file = file.path(base_dir, "edgeR_DGE_results.txt"),
            sep = "\t", quote = FALSE, row.names = FALSE)

cat("\nАнализ успешно завершен! Результаты сохранены в папку:", base_dir, "\n")
