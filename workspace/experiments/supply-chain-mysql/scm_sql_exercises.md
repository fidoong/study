# 企业级供应链中台系统 —— MySQL SQL 综合训练题

> **适用数据库**: MySQL 8.0+  
> **目标库**: `scm_platform`  
> **表结构来源**: `scm_schema.sql`（共 12 大模块，约 50+ 张表）  
> **训练目标**: 覆盖企业级业务查询、复杂关联分析、窗口函数、递归 CTE、JSON 操作、性能优化思维。

---

## 难度标识

| 标识 | 含义 | 建议受众 |
|---|---|---|
| ⭐ | 基础 | 熟悉表结构与单表查询 |
| ⭐⭐ | 进阶 | 掌握 JOIN、聚合、子查询 |
| ⭐⭐⭐ | 高级 | 窗口函数、CTE、JSON、复杂业务闭环 |
| ⭐⭐⭐⭐ | 实战/优化 | 综合多模块、性能调优、行转列、数据治理 |

---

## 模块一：基础数据层与商品中心（Foundation & Product）

### P1. 查询所有启用的二级商品类目 ⭐
**业务场景**: 运营后台需要展示所有二级类目用于绑定商品。  
**考查点**: 条件过滤、层级判断。  
**涉及表**: `category`

```sql
SELECT category_code, category_name, parent_id, level
FROM category
WHERE status = 1 AND level = 2
ORDER BY sort_order, id;
```

---

### P2. 查询商品 SPU 及其对应的品牌名称和类目名称 ⭐⭐
**业务场景**: 商品列表页展示 SPU 基础信息。  
**考查点**: 多表 LEFT JOIN、别名。  
**涉及表**: `product_spu`, `brand`, `category`

```sql
SELECT s.spu_code, s.spu_name, b.brand_name, c.category_name, s.unit, s.status
FROM product_spu s
LEFT JOIN brand b ON s.brand_id = b.id
LEFT JOIN category c ON s.category_id = c.id
WHERE s.deleted_at IS NULL
ORDER BY s.created_at DESC;
```

---

### P3. 统计每个一级类目下有多少个 SPU ⭐⭐
**业务场景**: 分析各类目商品丰富度。  
**考查点**: JOIN + GROUP BY + COUNT。  
**涉及表**: `category`, `product_spu`

```sql
SELECT c.category_name, COUNT(s.id) AS spu_count
FROM category c
LEFT JOIN product_spu s ON c.id = s.category_id AND s.deleted_at IS NULL
WHERE c.level = 1 AND c.status = 1
GROUP BY c.id, c.category_name
ORDER BY spu_count DESC;
```

---

### P4. 找出当前没有绑定任何 SKU 的 SPU（空壳商品） ⭐⭐
**业务场景**: 数据治理，清理未完善商品。  
**考查点**: NOT EXISTS / LEFT JOIN + IS NULL。  
**涉及表**: `product_spu`, `product_sku`

```sql
-- 方法1: NOT EXISTS
SELECT spu_code, spu_name
FROM product_spu s
WHERE NOT EXISTS (
    SELECT 1 FROM product_sku k WHERE k.spu_id = s.id
)
AND s.deleted_at IS NULL;

-- 方法2: LEFT JOIN
SELECT s.spu_code, s.spu_name
FROM product_spu s
LEFT JOIN product_sku k ON s.id = k.spu_id
WHERE k.id IS NULL AND s.deleted_at IS NULL;
```

---

### P5. 查询每个 SKU 当前的生效采购价、零售价（价格表中最新的有效记录） ⭐⭐⭐
**业务场景**: 价格管理中心查看最新有效价格。  
**考查点**: 关联子查询 / JOIN + 窗口函数取最新记录。  
**涉及表**: `product_sku`, `product_price`

```sql
-- 窗口函数版（推荐）
WITH latest_price AS (
    SELECT sku_id, price_type, price, effective_date,
           ROW_NUMBER() OVER (PARTITION BY sku_id, price_type ORDER BY effective_date DESC, id DESC) AS rn
    FROM product_price
    WHERE status = 1
      AND effective_date <= CURDATE()
      AND (expiry_date IS NULL OR expiry_date >= CURDATE())
)
SELECT k.sku_code, k.sku_name,
       MAX(CASE WHEN p.price_type = 1 THEN p.price END) AS purchase_price,
       MAX(CASE WHEN p.price_type = 3 THEN p.price END) AS sale_price
FROM product_sku k
LEFT JOIN latest_price p ON k.id = p.sku_id AND p.rn = 1
WHERE k.deleted_at IS NULL
GROUP BY k.id, k.sku_code, k.sku_name;
```

---

### P6. 解析 SKU 的 JSON 规格，列出所有包含 `"颜色": "红色"` 的 SKU ⭐⭐⭐
**业务场景**: 按规格属性筛选商品。  
**考查点**: MySQL JSON 函数 `JSON_CONTAINS`、`JSON_EXTRACT`、`->>`。  
**涉及表**: `product_sku`

```sql
SELECT sku_code, sku_name, sku_specs
FROM product_sku
WHERE JSON_CONTAINS(sku_specs, '"红色"', '$.颜色')
   OR sku_specs->>'$.颜色' = '红色';
```

---

### P7. 统计各品牌的 SKU 数量，并列出 TOP 10 ⭐⭐
**业务场景**: 品牌运营分析。  
**考查点**: 多表 JOIN、聚合、排序限制。  
**涉及表**: `brand`, `product_spu`, `product_sku`

```sql
SELECT b.brand_name, COUNT(k.id) AS sku_count
FROM brand b
LEFT JOIN product_spu s ON b.id = s.brand_id AND s.deleted_at IS NULL
LEFT JOIN product_sku k ON s.id = k.spu_id AND k.deleted_at IS NULL
WHERE b.status = 1
GROUP BY b.id, b.brand_name
ORDER BY sku_count DESC
LIMIT 10;
```

---

## 模块二：供应商管理（Supplier Management）

### S1. 查询信用等级为 5 星且合作状态为"合作中"的供应商列表 ⭐
**业务场景**: 优选供应商池筛选。  
**涉及表**: `supplier`

```sql
SELECT supplier_code, supplier_name, contact_name, contact_phone, province, city
FROM supplier
WHERE credit_level = 5 AND cooperate_status = 1 AND status = 1
ORDER BY created_at DESC;
```

---

### S2. 统计各省份的供应商数量，并按数量降序排列 ⭐
**业务场景**: 供应商地域分布分析。  
**涉及表**: `supplier`

```sql
SELECT province, COUNT(*) AS supplier_count
FROM supplier
WHERE status = 1 AND province IS NOT NULL
GROUP BY province
ORDER BY supplier_count DESC;
```

---

### S3. 查询每个供应商的首要联系人及合同数量 ⭐⭐
**业务场景**: 供应商档案卡信息汇总。  
**考查点**: 主表与多个从表关联。  
**涉及表**: `supplier`, `supplier_contact`, `supplier_contract`

```sql
SELECT s.supplier_code, s.supplier_name,
       c.contact_name, c.phone, c.email,
       COUNT(DISTINCT ct.id) AS contract_count
FROM supplier s
LEFT JOIN supplier_contact c ON s.id = c.supplier_id AND c.is_primary = 1 AND c.status = 1
LEFT JOIN supplier_contract ct ON s.id = ct.supplier_id AND ct.status = 1
WHERE s.status = 1
GROUP BY s.id, s.supplier_code, s.supplier_name, c.contact_name, c.phone, c.email;
```

---

### S4. 找出"近一年内没有任何采购订单"的供应商 ⭐⭐⭐
**业务场景**: 评估供应商活跃度，淘汰沉睡供应商。  
**考查点**: NOT EXISTS + 日期函数。  
**涉及表**: `supplier`, `purchase_order`

```sql
SELECT s.id, s.supplier_code, s.supplier_name, s.cooperate_status
FROM supplier s
WHERE NOT EXISTS (
    SELECT 1 FROM purchase_order po
    WHERE po.supplier_id = s.id
      AND po.order_date >= DATE_SUB(CURDATE(), INTERVAL 1 YEAR)
      AND po.status IN (1,2,3,4)
)
AND s.status = 1;
```

---

### S5. 计算每个供应商近 4 个季度的平均综合评分，并给出评级趋势（上升/下降/持平） ⭐⭐⭐⭐
**业务场景**: 供应商年度绩效考核。  
**考查点**: 窗口函数 `LAG`、条件判断。  
**涉及表**: `supplier_rating`

```sql
WITH quarterly_avg AS (
    SELECT supplier_id, rating_period,
           ROUND(AVG(total_score), 2) AS avg_score,
           LAG(ROUND(AVG(total_score), 2)) OVER (PARTITION BY supplier_id ORDER BY rating_period) AS prev_score
    FROM supplier_rating
    WHERE status = 1
    GROUP BY supplier_id, rating_period
)
SELECT supplier_id, rating_period, avg_score,
       CASE
           WHEN prev_score IS NULL THEN '首评'
           WHEN avg_score > prev_score THEN '上升'
           WHEN avg_score < prev_score THEN '下降'
           ELSE '持平'
       END AS trend
FROM quarterly_avg
ORDER BY supplier_id, rating_period;
```

---

### S6. 查询即将在 30 天内到期的供应商合同，并带上供应商名称和剩余天数 ⭐⭐
**业务场景**: 合同到期预警。  
**考查点**: 日期运算 `DATEDIFF`。  
**涉及表**: `supplier_contract`, `supplier`

```sql
SELECT c.contract_no, s.supplier_name, c.contract_name,
       c.end_date, DATEDIFF(c.end_date, CURDATE()) AS remaining_days
FROM supplier_contract c
JOIN supplier s ON c.supplier_id = s.id
WHERE c.status = 1
  AND c.end_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
ORDER BY remaining_days;
```

---

## 模块三：采购管理（Procurement）

### PR1. 查询某个采购员本月创建的采购订单总金额与订单数 ⭐
**业务场景**: 采购员 KPI 统计。  
**涉及表**: `purchase_order`

```sql
SELECT buyer_id,
       COUNT(*) AS order_count,
       ROUND(SUM(total_amount), 2) AS total_amount
FROM purchase_order
WHERE status != 0
  AND order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY buyer_id;
```

---

### PR2. 查询已审批通过但未转采购的采购申请单（存在未处理的申请明细） ⭐⭐
**业务场景**: 跟进采购申请落地情况，避免需求遗漏。  
**考查点**: 主从表状态不一致分析。  
**涉及表**: `purchase_request`, `purchase_request_item`

```sql
SELECT r.request_no, r.org_id, r.requester_id, r.request_date, r.total_amount
FROM purchase_request r
WHERE r.approval_status = 2  -- 已通过
  AND r.status IN (1, 3)     -- 待处理 / 部分采购
  AND EXISTS (
      SELECT 1 FROM purchase_request_item i
      WHERE i.request_id = r.id AND i.status = 1  -- 待处理
  )
ORDER BY r.request_date;
```

---

### PR3. 统计各供应商的年度采购金额、订单数、平均订单金额 ⭐⭐
**业务场景**: 供应商采购份额分析。  
**涉及表**: `purchase_order`, `supplier`

```sql
SELECT s.supplier_name,
       COUNT(po.id) AS order_count,
       ROUND(SUM(po.total_amount), 2) AS total_amount,
       ROUND(AVG(po.total_amount), 2) AS avg_order_amount
FROM purchase_order po
JOIN supplier s ON po.supplier_id = s.id
WHERE po.status != 0
  AND po.order_date >= CONCAT(YEAR(CURDATE()), '-01-01')
GROUP BY s.id, s.supplier_name
ORDER BY total_amount DESC;
```

---

### PR4. 查询采购订单中，实际到货日期晚于预计到货日期超过 7 天的记录（采购逾期） ⭐⭐
**业务场景**: 供应链交付及时率监控。  
**考查点**: 日期差值计算、NULL 判断。  
**涉及表**: `purchase_order`

```sql
SELECT order_no, supplier_id, expect_date, arrive_date,
       DATEDIFF(arrive_date, expect_date) AS delay_days
FROM purchase_order
WHERE status IN (3, 4)
  AND arrive_date IS NOT NULL
  AND expect_date IS NOT NULL
  AND DATEDIFF(arrive_date, expect_date) > 7
ORDER BY delay_days DESC;
```

---

### PR5. 查询每个 SKU 在近 6 个月的累计采购量与累计入库量，计算入库达成率 ⭐⭐⭐
**业务场景**: 采购执行闭环分析。  
**考查点**: 多表 JOIN + 聚合 + 比率计算（注意除零）。  
**涉及表**: `purchase_order_item`, `purchase_in_stock_item`

```sql
WITH po_agg AS (
    SELECT sku_id, SUM(qty) AS po_qty
    FROM purchase_order_item
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
      AND status != 0
    GROUP BY sku_id
),
in_agg AS (
    SELECT sku_id, SUM(actual_qty) AS in_qty
    FROM purchase_in_stock_item
    WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
      AND status != 0
    GROUP BY sku_id
)
SELECT k.sku_code, k.sku_name,
       COALESCE(po.po_qty, 0) AS po_qty,
       COALESCE(in_.in_qty, 0) AS in_qty,
       CASE WHEN COALESCE(po.po_qty, 0) = 0 THEN NULL
            ELSE ROUND(COALESCE(in_.in_qty, 0) / po.po_qty * 100, 2)
       END AS fulfillment_rate
FROM product_sku k
LEFT JOIN po_agg po ON k.id = po.sku_id
LEFT JOIN in_agg in_ ON k.id = in_.sku_id
WHERE po.po_qty > 0 OR in_.in_qty > 0
ORDER BY fulfillment_rate ASC;
```

---

### PR6. 查询存在"采购数量 ≠ 已收货数量 + 已退货数量"的采购订单明细（数据一致性校验） ⭐⭐⭐
**业务场景**: 财务对账与数据治理。  
**考查点**: 数值校验、精度处理。  
**涉及表**: `purchase_order_item`

```sql
SELECT order_id, sku_id, sku_name, qty, received_qty, returned_qty,
       (received_qty + returned_qty) AS accounted_qty,
       (qty - received_qty - returned_qty) AS diff_qty
FROM purchase_order_item
WHERE status != 0
  AND ABS(qty - received_qty - returned_qty) > 0.0001
ORDER BY ABS(qty - received_qty - returned_qty) DESC;
```

---

### PR7. 按月统计采购入库金额，并计算环比增长率 ⭐⭐⭐
**业务场景**: 采购金额月度趋势分析。  
**考查点**: 窗口函数 `LAG`、日期格式化。  
**涉及表**: `purchase_in_stock`

```sql
WITH monthly AS (
    SELECT DATE_FORMAT(in_stock_date, '%Y-%m') AS month,
           ROUND(SUM(total_amount), 2) AS total_amount
    FROM purchase_in_stock
    WHERE status = 3 AND deleted_at IS NULL
    GROUP BY DATE_FORMAT(in_stock_date, '%Y-%m')
)
SELECT month, total_amount,
       LAG(total_amount) OVER (ORDER BY month) AS prev_amount,
       CASE WHEN LAG(total_amount) OVER (ORDER BY month) IS NULL THEN NULL
            WHEN LAG(total_amount) OVER (ORDER BY month) = 0 THEN NULL
            ELSE ROUND((total_amount - LAG(total_amount) OVER (ORDER BY month)) / LAG(total_amount) OVER (ORDER BY month) * 100, 2)
       END AS mom_growth_pct
FROM monthly
ORDER BY month;
```

---

## 模块四：库存管理（Inventory Management）

### I1. 查询各仓库的库存 SKU 种类数、总库存数量、总库存金额 ⭐⭐
**业务场景**: 全局库存概览。  
**涉及表**: `inventory`, `warehouse`

```sql
SELECT w.warehouse_name,
       COUNT(DISTINCT i.sku_id) AS sku_count,
       ROUND(SUM(i.total_qty), 2) AS total_qty,
       ROUND(SUM(i.total_cost), 2) AS total_cost
FROM warehouse w
LEFT JOIN inventory i ON w.id = i.warehouse_id AND i.status = 1
WHERE w.status = 1
GROUP BY w.id, w.warehouse_name
ORDER BY total_cost DESC;
```

---

### I2. 查询低于安全库存的 SKU 列表，并提示缺口数量 ⭐⭐
**业务场景**: 库存预警——安全库存监控。  
**涉及表**: `inventory`, `product_sku`, `warehouse`

```sql
SELECT w.warehouse_name, k.sku_code, k.sku_name,
       i.available_qty, i.safety_stock,
       (i.safety_stock - i.available_qty) AS shortage_qty
FROM inventory i
JOIN product_sku k ON i.sku_id = k.id
JOIN warehouse w ON i.warehouse_id = w.id
WHERE i.available_qty < i.safety_stock
  AND i.status = 1
ORDER BY shortage_qty DESC;
```

---

### I3. 查询某 SKU 在各仓库的库存分布，并用行转列展示各状态库存 ⭐⭐⭐
**业务场景**: 一店一仓库存视图。  
**考查点**: 条件聚合实现行转列。  
**涉及表**: `inventory`, `warehouse`

```sql
SELECT w.warehouse_name,
       MAX(i.available_qty) AS available_qty,
       MAX(i.frozen_qty) AS frozen_qty,
       MAX(i.locked_qty) AS locked_qty,
       MAX(i.on_way_qty) AS on_way_qty,
       MAX(i.total_qty) AS total_qty
FROM inventory i
JOIN warehouse w ON i.warehouse_id = w.id
WHERE i.sku_id = 10001  -- 替换为目标 SKU
GROUP BY w.id, w.warehouse_name;
```

---

### I4. 查询近 30 天内没有任何出入库流水的 SKU（呆滞库存嫌疑） ⭐⭐⭐
**业务场景**: 呆滞品识别。  
**考查点**: NOT EXISTS + 时间范围。  
**涉及表**: `inventory`, `inventory_log`

```sql
SELECT k.sku_code, k.sku_name, w.warehouse_name, i.available_qty
FROM inventory i
JOIN product_sku k ON i.sku_id = k.id
JOIN warehouse w ON i.warehouse_id = w.id
WHERE i.available_qty > 0
  AND NOT EXISTS (
      SELECT 1 FROM inventory_log l
      WHERE l.sku_id = i.sku_id
        AND l.warehouse_id = i.warehouse_id
        AND l.operation_time >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
  )
ORDER BY i.available_qty DESC;
```

---

### I5. 统计每个仓库的盘点差异率（差异 SKU 数 / 总 SKU 数） ⭐⭐⭐
**业务场景**: 仓库盘点质量评估。  
**涉及表**: `stock_take`, `stock_take_item`

```sql
SELECT w.warehouse_name,
       COUNT(DISTINCT CASE WHEN ti.diff_qty != 0 THEN ti.sku_id END) AS diff_sku_count,
       COUNT(DISTINCT ti.sku_id) AS total_sku_count,
       ROUND(
         COUNT(DISTINCT CASE WHEN ti.diff_qty != 0 THEN ti.sku_id END)
         / NULLIF(COUNT(DISTINCT ti.sku_id), 0) * 100,
         2
       ) AS diff_rate_pct
FROM stock_take t
JOIN stock_take_item ti ON t.id = ti.take_id
JOIN warehouse w ON t.warehouse_id = w.id
WHERE t.status = 4
GROUP BY w.id, w.warehouse_name
ORDER BY diff_rate_pct DESC;
```

---

### I6. 查询库存调拨在途超过 7 天仍未完成的调拨单 ⭐⭐
**业务场景**: 调拨在途监控，防止货物丢失。  
**涉及表**: `stock_transfer`

```sql
SELECT transfer_no,
       from_warehouse_id, to_warehouse_id,
       apply_date, ship_date, receive_date,
       DATEDIFF(CURDATE(), ship_date) AS in_transit_days
FROM stock_transfer
WHERE status IN (3, 4)  -- 已出库 / 运输中
  AND ship_date IS NOT NULL
  AND receive_date IS NULL
  AND DATEDIFF(CURDATE(), ship_date) > 7
ORDER BY in_transit_days DESC;
```

---

### I7. 查询即将在 30 天内过期的库存批次，并关联仓库和 SKU 信息 ⭐⭐⭐
**业务场景**: 效期预警（食品、医药等行业刚需）。  
**涉及表**: `inventory_batch`, `product_sku`, `warehouse`

```sql
SELECT w.warehouse_name, k.sku_code, k.sku_name,
       ib.batch_no, ib.production_date, ib.expiry_date,
       ib.available_qty,
       DATEDIFF(ib.expiry_date, CURDATE()) AS remaining_days
FROM inventory_batch ib
JOIN product_sku k ON ib.sku_id = k.id
JOIN warehouse w ON ib.warehouse_id = w.id
WHERE ib.expiry_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY)
  AND ib.available_qty > 0
  AND ib.status = 1
ORDER BY remaining_days, w.warehouse_name;
```

---

### I8. 计算各 SKU 的库存周转天数（近 30 天平均出库量 vs 当前可用库存） ⭐⭐⭐⭐
**业务场景**: 库存健康度分析。  
**考查点**: 聚合 + 除零保护 + JOIN。  
**涉及表**: `inventory`, `inventory_log`

```sql
WITH out_avg AS (
    SELECT sku_id, warehouse_id,
           ABS(AVG(change_qty)) AS avg_daily_out  -- change_qty 出库为负
    FROM inventory_log
    WHERE business_type IN (3, 6, 9)  -- 销售出库 / 调拨出库 / 其他出库
      AND operation_time >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY sku_id, warehouse_id
)
SELECT k.sku_code, k.sku_name, w.warehouse_name,
       i.available_qty,
       ROUND(COALESCE(a.avg_daily_out, 0), 2) AS avg_daily_out_30d,
       CASE WHEN COALESCE(a.avg_daily_out, 0) = 0 THEN NULL
            ELSE ROUND(i.available_qty / a.avg_daily_out, 1)
       END AS turnover_days
FROM inventory i
JOIN product_sku k ON i.sku_id = k.id
JOIN warehouse w ON i.warehouse_id = w.id
LEFT JOIN out_avg a ON i.sku_id = a.sku_id AND i.warehouse_id = a.warehouse_id
WHERE i.available_qty > 0
ORDER BY ISNULL(turnover_days), turnover_days DESC;
```

---

## 模块五：销售管理（Sales Management）

### SM1. 查询本月销售额 TOP 10 的客户 ⭐⭐
**业务场景**: 大客户业绩排名。  
**涉及表**: `customer`, `sales_order`

```sql
SELECT c.customer_code, c.customer_name,
       COUNT(DISTINCT o.id) AS order_count,
       ROUND(SUM(o.payable_amount), 2) AS total_amount
FROM sales_order o
JOIN customer c ON o.customer_id = c.id
WHERE o.status IN (2, 3, 4)
  AND o.order_date >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
GROUP BY c.id, c.customer_code, c.customer_name
ORDER BY total_amount DESC
LIMIT 10;
```

---

### SM2. 查询销售订单中，已发货数量 < 销售数量 的订单明细（欠货） ⭐⭐
**业务场景**: 发货缺货跟踪。  
**涉及表**: `sales_order_item`

```sql
SELECT oi.order_id, oi.sku_id, oi.sku_name, oi.qty, oi.delivered_qty,
       (oi.qty - oi.delivered_qty) AS backlog_qty
FROM sales_order_item oi
WHERE oi.status IN (1, 2)
  AND oi.qty > oi.delivered_qty
ORDER BY backlog_qty DESC;
```

---

### SM3. 统计各销售代表的本季度业绩、订单数、平均客单价 ⭐⭐⭐
**业务场景**: 销售团队季度考核。  
**考查点**: 季度时间范围计算、多维度聚合。  
**涉及表**: `sales_order`, `sys_user`

```sql
SELECT u.real_name AS sales_rep,
       COUNT(DISTINCT o.id) AS order_count,
       ROUND(SUM(o.payable_amount), 2) AS total_amount,
       ROUND(AVG(o.payable_amount), 2) AS avg_order_value
FROM sales_order o
LEFT JOIN sys_user u ON o.sales_rep_id = u.id
WHERE o.status IN (2, 3, 4)
  AND o.order_date >= CONCAT(YEAR(CURDATE()), '-', QUARTER(CURDATE()) * 3 - 2, '-01')
GROUP BY o.sales_rep_id, u.real_name
ORDER BY total_amount DESC;
```

---

### SM4. 查询客户信用额度使用率超过 80% 的客户 ⭐⭐
**业务场景**: 信用风险预警。  
**涉及表**: `customer`

```sql
SELECT customer_code, customer_name, credit_limit, credit_used,
       ROUND(credit_used / credit_limit * 100, 2) AS usage_pct
FROM customer
WHERE credit_limit > 0
  AND credit_used / credit_limit > 0.80
ORDER BY usage_pct DESC;
```

---

### SM5. 按月统计销售退货率（退货金额 / 销售金额），并找出异常月份 ⭐⭐⭐
**业务场景**: 品质与售后分析。  
**涉及表**: `sales_order`, `sales_return`

```sql
WITH sales_monthly AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
           SUM(total_amount) AS sale_amount
    FROM sales_order
    WHERE status IN (2, 3, 4, 5)
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
return_monthly AS (
    SELECT DATE_FORMAT(return_date, '%Y-%m') AS month,
           SUM(total_amount) AS return_amount
    FROM sales_return
    WHERE status IN (2, 3)
    GROUP BY DATE_FORMAT(return_date, '%Y-%m')
)
SELECT s.month,
       ROUND(s.sale_amount, 2) AS sale_amount,
       ROUND(COALESCE(r.return_amount, 0), 2) AS return_amount,
       ROUND(COALESCE(r.return_amount, 0) / NULLIF(s.sale_amount, 0) * 100, 2) AS return_rate_pct
FROM sales_monthly s
LEFT JOIN return_monthly r ON s.month = r.month
ORDER BY s.month;
```

---

### SM6. 查询连续 3 个月都有下单的客户（忠诚客户识别） ⭐⭐⭐⭐
**业务场景**: 客户分层运营。  
**考查点**: 窗口函数 `ROW_NUMBER` 做日期连续性判断。  
**涉及表**: `sales_order`

```sql
WITH monthly_orders AS (
    SELECT customer_id, DATE_FORMAT(order_date, '%Y-%m') AS month
    FROM sales_order
    WHERE status IN (2, 3, 4)
    GROUP BY customer_id, DATE_FORMAT(order_date, '%Y-%m')
),
numbered AS (
    SELECT customer_id, month,
           ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY month) AS rn,
           DATE_SUB(STR_TO_DATE(CONCAT(month, '-01'), '%Y-%m-%d'), INTERVAL ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY month) MONTH) AS grp
    FROM monthly_orders
),
groups AS (
    SELECT customer_id, grp, COUNT(*) AS consecutive_months
    FROM numbered
    GROUP BY customer_id, grp
    HAVING COUNT(*) >= 3
)
SELECT c.customer_code, c.customer_name
FROM groups g
JOIN customer c ON g.customer_id = c.id
GROUP BY c.id, c.customer_code, c.customer_name
ORDER BY c.customer_code;
```

---

## 模块六：仓储作业与物流（WMS & TMS）

### W1. 查询今日待拣货的出库单列表及对应波次号 ⭐⭐
**业务场景**: 仓库拣货任务看板。  
**涉及表**: `wms_outbound`, `wave`

```sql
SELECT o.outbound_no, o.outbound_type, o.source_no, w.wave_no, o.priority, o.status
FROM wms_outbound o
LEFT JOIN wave w ON o.wave_id = w.id
WHERE o.status IN (2, 3)  -- 待分配 / 待拣货
  AND DATE(o.created_at) = CURDATE()
ORDER BY o.priority, o.created_at;
```

---

### W2. 统计各仓库的拣货单平均耗时（结束时间 - 开始时间） ⭐⭐⭐
**业务场景**: 仓库人效分析。  
**考查点**: 时间差函数 `TIMESTAMPDIFF`、AVG。  
**涉及表**: `pick_order`

```sql
SELECT w.warehouse_name,
       COUNT(*) AS pick_count,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, p.start_time, p.end_time)), 1) AS avg_minutes
FROM pick_order p
JOIN warehouse w ON p.warehouse_id = w.id
WHERE p.status IN (3, 4)
  AND p.start_time IS NOT NULL
  AND p.end_time IS NOT NULL
GROUP BY w.id, w.warehouse_name
ORDER BY avg_minutes DESC;
```

---

### W3. 查询已揽收但超过 48 小时未签收的运单（在途异常） ⭐⭐
**业务场景**: 物流异常监控。  
**涉及表**: `waybill`

```sql
SELECT waybill_no, carrier_id, business_no,
       ship_time, receive_time, logistics_status,
       TIMESTAMPDIFF(HOUR, ship_time, COALESCE(receive_time, NOW())) AS transit_hours
FROM waybill
WHERE logistics_status IN (1, 2, 3, 4)  -- 已揽收至派送中
  AND ship_time IS NOT NULL
  AND TIMESTAMPDIFF(HOUR, ship_time, COALESCE(receive_time, NOW())) > 48
ORDER BY transit_hours DESC;
```

---

### W4. 查询某运单的全部物流轨迹，并按时间排序 ⭐
**业务场景**: 物流详情页。  
**涉及表**: `waybill`, `logistics_track`

```sql
SELECT w.waybill_no, t.track_time, t.track_content, t.location, t.operator
FROM logistics_track t
JOIN waybill w ON t.waybill_id = w.id
WHERE w.waybill_no = 'WB20250001'
ORDER BY t.track_time;
```

---

### W5. 统计各承运商的准时签收率（预计时间内签收的比例） ⭐⭐⭐⭐
**业务场景**: 承运商 KPI。  
**涉及表**: `waybill`, `sales_order`

```sql
WITH waybill_expect AS (
    SELECT wb.id, wb.waybill_no, wb.carrier_id, wb.receive_time, so.expect_date
    FROM waybill wb
    JOIN sales_order so ON wb.business_id = so.id AND wb.business_type = 1
    WHERE wb.logistics_status = 5
)
SELECT c.carrier_name,
       COUNT(*) AS total_delivered,
       SUM(CASE WHEN w.receive_time <= TIMESTAMP(w.expect_date, '23:59:59') THEN 1 ELSE 0 END) AS on_time_count,
       ROUND(
         SUM(CASE WHEN w.receive_time <= TIMESTAMP(w.expect_date, '23:59:59') THEN 1 ELSE 0 END)
         / COUNT(*) * 100,
         2
       ) AS on_time_rate_pct
FROM waybill_expect w
JOIN carrier c ON w.carrier_id = c.id
GROUP BY c.id, c.carrier_name
ORDER BY on_time_rate_pct DESC;
```

---

## 模块七：财务管理（Finance）

### F1. 查询本月到期但未付清的应付单，并计算逾期天数 ⭐⭐
**业务场景**: 付款资金计划。  
**涉及表**: `account_payable`, `supplier`

```sql
SELECT ap.payable_no, s.supplier_name, ap.amount, ap.paid_amount, ap.unpaid_amount,
       ap.due_date, DATEDIFF(CURDATE(), ap.due_date) AS overdue_days
FROM account_payable ap
JOIN supplier s ON ap.supplier_id = s.id
WHERE ap.pay_status IN (0, 1)
  AND ap.due_date < CURDATE()
ORDER BY overdue_days DESC;
```

---

### F2. 统计各客户的应收账款账龄分布（0-30天、31-60天、61-90天、90天以上） ⭐⭐⭐⭐
**业务场景**: 财务催收与坏账准备。  
**考查点**: 行转列（CASE WHEN 聚合）。  
**涉及表**: `account_receivable`, `customer`

```sql
SELECT c.customer_name,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), ar.due_date) <= 30 THEN ar.unreceived_amount ELSE 0 END), 2) AS d_0_30,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), ar.due_date) BETWEEN 31 AND 60 THEN ar.unreceived_amount ELSE 0 END), 2) AS d_31_60,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), ar.due_date) BETWEEN 61 AND 90 THEN ar.unreceived_amount ELSE 0 END), 2) AS d_61_90,
       ROUND(SUM(CASE WHEN DATEDIFF(CURDATE(), ar.due_date) > 90 THEN ar.unreceived_amount ELSE 0 END), 2) AS d_90_plus,
       ROUND(SUM(ar.unreceived_amount), 2) AS total_unreceived
FROM account_receivable ar
JOIN customer c ON ar.customer_id = c.id
WHERE ar.receive_status IN (0, 1)
GROUP BY c.id, c.customer_name
ORDER BY total_unreceived DESC;
```

---

### F3. 查询存在"已开票金额 + 未开票金额 ≠ 应收金额"的数据异常记录 ⭐⭐
**业务场景**: 财务数据一致性校验。  
**涉及表**: `account_receivable`

```sql
SELECT receivable_no, amount, invoice_amount, uninvoice_amount,
       (invoice_amount + uninvoice_amount) AS summed_invoice
FROM account_receivable
WHERE ABS(amount - invoice_amount - uninvoice_amount) > 0.0001
   OR (invoice_amount + uninvoice_amount) < 0;
```

---

### F4. 按月统计进项发票与销项发票的含税金额，并计算月度税负率 ⭐⭐⭐
**业务场景**: 税务筹划与税负监控。  
**涉及表**: `invoice`

```sql
WITH monthly_invoice AS (
    SELECT DATE_FORMAT(invoice_date, '%Y-%m') AS month,
           SUM(CASE WHEN direction = 1 THEN amount_with_tax ELSE 0 END) AS input_tax_amount,
           SUM(CASE WHEN direction = 2 THEN amount_with_tax ELSE 0 END) AS output_tax_amount
    FROM invoice
    WHERE status = 1
    GROUP BY DATE_FORMAT(invoice_date, '%Y-%m')
)
SELECT month,
       ROUND(input_tax_amount, 2) AS input_tax_amount,
       ROUND(output_tax_amount, 2) AS output_tax_amount,
       CASE WHEN output_tax_amount = 0 THEN NULL
            ELSE ROUND((output_tax_amount - input_tax_amount) / output_tax_amount * 100, 2)
       END AS tax_burden_pct
FROM monthly_invoice
ORDER BY month;
```

---

### F5. 查询某结算单下关联的所有应付单与付款记录，展示结算闭环 ⭐⭐⭐
**业务场景**: 结算明细穿透查询。  
**考查点**: UNION ALL 合并不同来源数据。  
**涉及表**: `settlement`, `settlement_item`, `account_payable`, `payment_record`

```sql
SELECT si.source_no, si.amount AS original_amount, si.settle_amount,
       '应付单' AS source_category, ap.due_date, ap.pay_status
FROM settlement_item si
JOIN account_payable ap ON si.source_id = ap.id AND si.source_type = 1
WHERE si.settlement_id = 10001

UNION ALL

SELECT si.source_no, pr.amount AS original_amount, si.settle_amount,
       '付款记录' AS source_category, pr.payment_date AS due_date, pr.status AS pay_status
FROM settlement_item si
JOIN payment_record pr ON si.source_id = pr.id AND si.source_type = 3
WHERE si.settlement_id = 10001;
```

---

## 模块八：组织架构与权限（Organization & RBAC）

### O1. 使用递归 CTE 查询某组织节点的所有下属组织（含多级） ⭐⭐⭐⭐
**业务场景**: 组织树展开、数据权限范围查询。  
**考查点**: 递归 CTE (`WITH RECURSIVE`)。  
**涉及表**: `organization`

```sql
WITH RECURSIVE org_tree AS (
    SELECT id, org_code, org_name, parent_id, level, path
    FROM organization
    WHERE id = 1 AND deleted_at IS NULL

    UNION ALL

    SELECT o.id, o.org_code, o.org_name, o.parent_id, o.level, o.path
    FROM organization o
    INNER JOIN org_tree ot ON o.parent_id = ot.id
    WHERE o.deleted_at IS NULL
)
SELECT id, org_code, org_name, level, path
FROM org_tree
ORDER BY path, sort_order;
```

---

### O2. 查询拥有"采购经理"角色的所有用户，并列出其所属组织名称 ⭐⭐
**业务场景**: 权限审计。  
**涉及表**: `sys_user`, `user_role`, `sys_role`, `organization`

```sql
SELECT u.username, u.real_name, u.employee_no, o.org_name, r.role_name
FROM sys_user u
JOIN user_role ur ON u.id = ur.user_id
JOIN sys_role r ON ur.role_id = r.id
LEFT JOIN organization o ON u.org_id = o.id
WHERE r.role_code = 'purchase_manager'
  AND u.status = 1 AND u.deleted_at IS NULL
ORDER BY o.org_name, u.real_name;
```

---

## 模块九：质检与审批（QC & Approval）

### Q1. 统计各供应商的质检合格率（合格数量 / 送检总数量） ⭐⭐⭐
**业务场景**: 供应商来料质量监控。  
**涉及表**: `quality_check`, `quality_check_item`

```sql
SELECT s.supplier_name,
       SUM(qci.check_qty) AS total_check_qty,
       SUM(qci.qualified_qty) AS total_qualified_qty,
       ROUND(SUM(qci.qualified_qty) / NULLIF(SUM(qci.check_qty), 0) * 100, 2) AS pass_rate_pct
FROM quality_check qc
JOIN quality_check_item qci ON qc.id = qci.check_id
LEFT JOIN supplier s ON qc.supplier_id = s.id
WHERE qc.status = 3
GROUP BY qc.supplier_id, s.supplier_name
ORDER BY pass_rate_pct ASC;
```

---

### Q2. 查询每个审批单据的最新审批意见及审批人 ⭐⭐⭐
**业务场景**: 审批流程详情页。  
**考查点**: 窗口函数 `ROW_NUMBER` 取每组最新记录。  
**涉及表**: `approval_record`

```sql
WITH latest_approval AS (
    SELECT biz_type, biz_id, biz_no, step_name, approver_name, action, comment, approve_time,
           ROW_NUMBER() OVER (PARTITION BY biz_type, biz_id ORDER BY approve_time DESC) AS rn
    FROM approval_record
)
SELECT biz_type, biz_no, step_name, approver_name, action, comment, approve_time
FROM latest_approval
WHERE rn = 1
ORDER BY approve_time DESC;
```

---

### Q3. 统计各业务类型的平均审批时长（从第一条到最后一条的间隔） ⭐⭐⭐
**业务场景**: 流程效率优化。  
**涉及表**: `approval_record`

```sql
SELECT biz_type,
       COUNT(DISTINCT biz_id) AS biz_count,
       ROUND(AVG(TIMESTAMPDIFF(MINUTE, min_time, max_time)), 1) AS avg_approval_minutes
FROM (
    SELECT biz_type, biz_id,
           MIN(approve_time) AS min_time,
           MAX(approve_time) AS max_time
    FROM approval_record
    GROUP BY biz_type, biz_id
) t
GROUP BY biz_type
ORDER BY avg_approval_minutes DESC;
```

---

## 模块十：综合实战与数据治理（Advanced & Data Governance）

### A1. 库存快照：查询指定日期各 SKU 在指定仓库的库存数量 ⭐⭐⭐⭐
**业务场景**: 历史库存回溯。  
**考查点**: 利用 `inventory_log` 流水表做时间切片累加。  
**涉及表**: `inventory_log`

```sql
WITH snapshot AS (
    SELECT sku_id, warehouse_id,
           SUM(change_qty) AS snapshot_qty,
           SUM(change_cost) AS snapshot_cost
    FROM inventory_log
    WHERE operation_time < '2024-06-01'
      AND status = 1
    GROUP BY sku_id, warehouse_id
)
SELECT k.sku_code, k.sku_name, w.warehouse_name,
       COALESCE(s.snapshot_qty, 0) AS qty,
       COALESCE(s.snapshot_cost, 0) AS cost
FROM snapshot s
JOIN product_sku k ON s.sku_id = k.id
JOIN warehouse w ON s.warehouse_id = w.id
WHERE s.snapshot_qty != 0
ORDER BY w.warehouse_name, k.sku_code;
```

---

### A2. 数据治理：查询缺失首要联系人的供应商 ⭐
**业务场景**: 数据完整性校验。  
**涉及表**: `supplier`

```sql
SELECT supplier_code, supplier_name
FROM supplier
WHERE (contact_name IS NULL OR contact_phone IS NULL)
  AND status = 1;
```

---

### A3. 综合报表：生成"供应商 360 视图"——采购额、入库额、退货额、质检合格率 ⭐⭐⭐⭐
**业务场景**: 供应商综合评估仪表盘。  
**考查点**: 多事实表关联、COALESCE 补零。  
**涉及表**: `purchase_order`, `purchase_in_stock`, `purchase_return`, `quality_check`, `quality_check_item`

```sql
WITH po_summary AS (
    SELECT supplier_id,
           ROUND(SUM(total_amount), 2) AS po_amount
    FROM purchase_order
    WHERE status != 0
      AND order_date >= CONCAT(YEAR(CURDATE()), '-01-01')
    GROUP BY supplier_id
),
in_summary AS (
    SELECT supplier_id,
           ROUND(SUM(total_amount), 2) AS in_amount
    FROM purchase_in_stock
    WHERE status = 3
      AND in_stock_date >= CONCAT(YEAR(CURDATE()), '-01-01')
    GROUP BY supplier_id
),
rt_summary AS (
    SELECT supplier_id,
           ROUND(SUM(total_amount), 2) AS return_amount
    FROM purchase_return
    WHERE status IN (2, 3)
      AND return_date >= CONCAT(YEAR(CURDATE()), '-01-01')
    GROUP BY supplier_id
),
qc_summary AS (
    SELECT qc.supplier_id,
           ROUND(SUM(qci.qualified_qty) / NULLIF(SUM(qci.check_qty), 0) * 100, 2) AS pass_rate_pct
    FROM quality_check qc
    JOIN quality_check_item qci ON qc.id = qci.check_id
    WHERE qc.check_date >= CONCAT(YEAR(CURDATE()), '-01-01')
    GROUP BY qc.supplier_id
)
SELECT s.supplier_code, s.supplier_name,
       COALESCE(po.po_amount, 0) AS po_amount,
       COALESCE(in_.in_amount, 0) AS in_amount,
       COALESCE(rt.return_amount, 0) AS return_amount,
       COALESCE(qc.pass_rate_pct, 0) AS pass_rate_pct
FROM supplier s
LEFT JOIN po_summary po ON s.id = po.supplier_id
LEFT JOIN in_summary in_ ON s.id = in_.supplier_id
LEFT JOIN rt_summary rt ON s.id = rt.supplier_id
LEFT JOIN qc_summary qc ON s.id = qc.supplier_id
WHERE s.status = 1
ORDER BY po_amount DESC;
```

---

### A4. 查询同时是"供应商"又是"客户"的往来单位（既是对手又是伙伴） ⭐⭐⭐
**业务场景**: 集团内部交易、关联方识别。  
**考查点**: 跨模块关联（通常通过税号或名称匹配）。  
**涉及表**: `supplier`, `customer`

```sql
SELECT s.supplier_code, s.supplier_name, s.tax_no,
       c.customer_code, c.customer_name
FROM supplier s
JOIN customer c ON s.tax_no = c.tax_no
WHERE s.tax_no IS NOT NULL
  AND s.status = 1 AND c.status = 1;
```

---

### A5. 找出"本月有出库记录但无入库记录"的 SKU（只出不进预警） ⭐⭐⭐
**业务场景**: 异常库存流向监控。  
**考查点**: EXCEPT / LEFT JOIN 思想。  
**涉及表**: `wms_inbound_item`, `wms_outbound_item`

```sql
SELECT DISTINCT oi.sku_id, k.sku_code, k.sku_name
FROM wms_outbound_item oi
JOIN wms_outbound o ON oi.outbound_id = o.id
JOIN product_sku k ON oi.sku_id = k.id
WHERE DATE(o.out_stock_date) >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
  AND NOT EXISTS (
      SELECT 1 FROM wms_inbound_item ii
      JOIN wms_inbound i ON ii.inbound_id = i.id
      WHERE ii.sku_id = oi.sku_id
        AND DATE(i.in_stock_date) >= DATE_FORMAT(CURDATE(), '%Y-%m-01')
  );
```

---

### A6. 分析采购价格波动：某 SKU 最新采购价相比上一个有效采购价的涨跌幅度 ⭐⭐⭐⭐
**业务场景**: 采购价格监控。  
**考查点**: 窗口函数 `LAG` 配合时间筛选。  
**涉及表**: `product_price` / `supplier_product`

```sql
WITH ranked_prices AS (
    SELECT sku_id, purchase_price, effective_date,
           LAG(purchase_price) OVER (PARTITION BY sku_id ORDER BY effective_date) AS prev_price
    FROM supplier_product
    WHERE status = 1
)
SELECT sku_id, purchase_price, prev_price, effective_date,
       CASE WHEN prev_price IS NULL THEN NULL
            ELSE ROUND((purchase_price - prev_price) / prev_price * 100, 2)
       END AS change_pct
FROM ranked_prices
WHERE effective_date >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH)
  AND prev_price IS NOT NULL
ORDER BY ABS(change_pct) DESC;
```

---

### A7. 为运营生成一张"商品条码汇总表"：每个 SKU 的国标码、箱码、托盘码列转行展示 ⭐⭐⭐
**业务场景**: 条码管理视图。  
**考查点**: 条件聚合实现列转行。  
**涉及表**: `product_barcode`

```sql
SELECT sku_id,
       MAX(CASE WHEN barcode_type = 1 THEN barcode END) AS national_code,
       MAX(CASE WHEN barcode_type = 3 THEN barcode END) AS box_code,
       MAX(CASE WHEN barcode_type = 4 THEN barcode END) AS pallet_code,
       MAX(CASE WHEN barcode_type = 1 THEN qty_ratio END) AS box_ratio
FROM product_barcode
WHERE status = 1
GROUP BY sku_id;
```

---

### A8. 分页查询销售订单列表，要求按订单金额倒序并返回第 3 页（每页 20 条） ⭐⭐
**业务场景**: 标准分页接口 SQL。  
**考查点**: `LIMIT` + `OFFSET` 或游标分页。  
**涉及表**: `sales_order`

```sql
-- 传统分页（适用于数据量中等场景）
SELECT order_no, customer_id, order_date, payable_amount, status
FROM sales_order
WHERE deleted_at IS NULL
ORDER BY payable_amount DESC, id DESC
LIMIT 20 OFFSET 40;

-- 推荐：基于游标的分页（深分页优化，需前端传入上一页最后一条的 payable_amount 和 id）
SELECT order_no, customer_id, order_date, payable_amount, status
FROM sales_order
WHERE deleted_at IS NULL
  AND (payable_amount, id) < (上一页最后金额, 上一页最后ID)
ORDER BY payable_amount DESC, id DESC
LIMIT 20;
```

---

### A9. 为仓库生成库位利用率报表：已用库位数 / 总库位数 ⭐⭐
**业务场景**: 仓库容量规划。  
**涉及表**: `warehouse_location`

```sql
SELECT w.warehouse_name,
       COUNT(*) AS total_locations,
       SUM(CASE WHEN is_empty = 0 THEN 1 ELSE 0 END) AS used_locations,
       ROUND(SUM(CASE WHEN is_empty = 0 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS utilization_pct
FROM warehouse_location wl
JOIN warehouse w ON wl.warehouse_id = w.id
WHERE wl.status = 1
GROUP BY w.id, w.warehouse_name
ORDER BY utilization_pct DESC;
```

---

### A10. 操作日志审计：查询某业务单据在一天内被修改超过 3 次的记录 ⭐⭐⭐
**业务场景**: 数据安全与操作审计。  
**考查点**: HAVING 过滤聚合结果。  
**涉及表**: `operation_log`

```sql
SELECT biz_type, biz_no, DATE(operation_time) AS op_date,
       COUNT(*) AS modify_count,
       GROUP_CONCAT(DISTINCT action ORDER BY action) AS actions
FROM operation_log
WHERE action IN ('update', 'approve', 'cancel')
GROUP BY biz_type, biz_id, biz_no, DATE(operation_time)
HAVING COUNT(*) > 3
ORDER BY modify_count DESC;
```

---

## 附录：核心知识点速查

| 技术点 | 典型应用场景 | 示例题号 |
|---|---|---|
| `WITH RECURSIVE` | 组织架构树、类目层级、多级推荐 | O1 |
| `ROW_NUMBER / RANK / LAG / LEAD` | 最新价格、趋势分析、TOP N | P5, S5, PR7, SM6, A6 |
| `JSON_CONTAINS / ->> / JSON_EXTRACT` | SKU 规格筛选、系统配置读取 | P6 |
| `CASE WHEN` 聚合 | 账龄分析、状态行转列、分类统计 | F2, A7, I3 |
| `DATEDIFF / TIMESTAMPDIFF` | 逾期计算、时效分析、库龄 | S6, PR4, F1, I7 |
| `NOT EXISTS` | 沉睡供应商、呆滞库存、只出不进 | S4, I4, A5 |
| `UNION ALL` | 结算穿透、合并异构流水 | F5 |
| `GROUP_CONCAT` | 审计日志聚合、多值合并 | A10 |
| 深分页优化 | 大数据量订单列表 | A8 |
| 数据一致性校验 | 财务对账、库存闭环 | PR6, F3 |

---

> **练习建议**
> 1. 先通读 `scm_schema.sql`，理解各表之间的业务关系与字段含义。
> 2. 按模块顺序练习，从 ⭐ 到 ⭐⭐⭐⭐ 逐步提升。
> 3. 每道题建议先用 `EXPLAIN` 查看执行计划，关注是否命中索引、是否存在全表扫描。
> 4. 对于窗口函数与 CTE 题目，尝试改写为子查询版本，对比可读性与性能差异。
> 5. 在真实业务环境中，注意 `DECIMAL` 精度运算、NULL 值处理、时区统一等问题。
