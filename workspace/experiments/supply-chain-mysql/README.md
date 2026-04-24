# 企业级供应链中台系统 - MySQL 设计与学习套件

## 📦 项目简介

本套件提供一套完整的**企业级供应链中台系统**的 MySQL 表结构设计、测试数据生成脚本，以及**90道**由浅入深的 SQL 练习题。适合用于：

- MySQL 进阶学习与实战训练
- 供应链业务知识理解
- 面试准备与技能检验
- 企业级数据库设计参考

---

## 📁 文件结构

```
supply-chain-mysql/
├── scm_schema.sql      # DDL 建表脚本 (40张表, ~1600行)
├── scm_data.sql        # 随机数据生成脚本 (~750行)
├── scm_exercises.md    # SQL 练习题集 (90题, ~1700行)
└── README.md           # 本文件
```

---

## 🗄️ 数据库概览

### 数据库名
`scm_platform`

### 表数量
**40张表**，覆盖9大业务模块：

| 模块 | 表数 | 核心表 |
|------|------|--------|
| 基础数据层 | 7 | organization, sys_user, sys_role, dict_type, dict_data |
| 商品中心 | 6 | category, brand, product_spu, product_sku, product_price, product_barcode |
| 供应商管理 | 4 | supplier, supplier_contact, supplier_rating, supplier_contract |
| 采购管理 | 6 | purchase_request, purchase_request_item, purchase_order, purchase_order_item, purchase_in_stock, purchase_return |
| 库存管理 | 8 | warehouse, warehouse_location, inventory, inventory_log, stock_take, stock_take_item, stock_transfer, stock_transfer_item |
| 销售管理 | 6 | customer_level, customer, sales_order, sales_order_item, sales_out_stock, sales_return |
| 仓储作业(WMS) | 7 | wms_inbound, wms_inbound_item, wms_outbound, wms_outbound_item, wave, pick_order, pick_order_item |
| 物流管理(TMS) | 4 | carrier, waybill, logistics_track, freight_template |
| 财务管理 | 5 | account_payable, account_receivable, invoice, settlement, payment_record |

### 数据规模（执行数据脚本后）

| 数据类型 | 数量 |
|----------|------|
| 组织架构 | 13条 |
| 用户/角色 | 10用户 / 10角色 |
| 品牌 | 20个 |
| 商品类目 | 15个（3级树） |
| 商品SPU | 200个 |
| 商品SKU | 约600个 |
| 供应商 | 80家 |
| 客户 | 200家 |
| 仓库 | 10个 |
| 库位 | 约800个 |
| 库存记录 | 约900条 |
| 采购订单 | 500单 / ~1500明细 |
| 销售订单 | 800单 / ~2400明细 |
| 库存流水 | 3000条 |
| 盘点/调拨 | 各50单 |
| 运单 | 300单 / ~1200跟踪记录 |
| 应付/应收 | 各200单 |
| 发票 | 150张 |
| 付款记录 | 100条 |

---

## 🚀 快速开始

### 1. 创建数据库与表结构

```bash
mysql -u root -p < scm_schema.sql
```

### 2. 生成测试数据

```bash
mysql -u root -p < scm_data.sql
```

> ⚠️ 注意：数据脚本会清除原有数据（TRUNCATE），请确保在生产环境**不要**执行！

### 3. 连接数据库开始练习

```bash
mysql -u root -p scm_platform
```

---

## 📚 练习题指南

### 题目分布

| 级别 | 主题 | 题数 | 难度 |
|------|------|------|------|
| L1 | 基础查询 | 8 | ⭐ |
| L2 | 多表关联 | 10 | ⭐⭐ |
| L3 | 聚合统计 | 10 | ⭐⭐ |
| L4 | 子查询与派生 | 8 | ⭐⭐⭐ |
| L5 | 窗口函数 | 10 | ⭐⭐⭐ |
| L6 | CTE递归 | 6 | ⭐⭐⭐ |
| L7 | DML与事务 | 6 | ⭐⭐ |
| L8 | 存储过程与函数 | 6 | ⭐⭐⭐ |
| L9 | 视图与触发器 | 4 | ⭐⭐ |
| L10 | 性能与优化 | 12 | ⭐⭐⭐⭐ |
| L11 | 综合业务实战 | 10 | ⭐⭐⭐⭐ |
| **合计** | | **90** | |

### 推荐学习路线

```
基础夯实:  L1 → L2 → L3
进阶提升:  L4 → L5 → L6 → L7
高级应用:  L8 → L9 → L10
业务实战:  L11
```

### 练习建议

1. **先尝试自己写**：看题目描述后，先不看答案自己实现
2. **对比优化**：与参考答案对比，思考是否有更优写法
3. **EXPLAIN验证**：对每道题执行 `EXPLAIN`，观察索引使用和执行计划
4. **变式练习**：修改 WHERE 条件、增加 JOIN 表、调整排序规则进行扩展

---

## 🏗️ 设计亮点

### 1. 统一的审计字段
每张表均包含：
- `created_at` / `updated_at` - 时间戳
- `created_by` / `updated_by` - 操作人
- `deleted_at` - 软删除支持
- `version` - 乐观锁版本号
- `remark` - 备注

### 2. 合理的索引设计
- 主键 + 唯一索引（业务编码）
- 外键索引（关联查询）
- 组合索引（多条件查询）
- 全文索引（商品名称搜索）

### 3. 分区表实践
`inventory_log` 按 `operation_time` 的年份进行 RANGE 分区，便于历史数据管理和查询裁剪。

### 4. 数据类型规范
- 金额/数量：DECIMAL(18,4) 保证精度
- 状态/类型：TINYINT UNSIGNED 节省空间
- JSON字段：sku_specs, spec_template 等灵活属性
- 时间：DATETIME + 默认 CURRENT_TIMESTAMP

---

## ⚠️ 注意事项

1. **外键约束**：生产环境建议在应用层控制外键，脚本中外键已注释
2. **数据安全**：`scm_data.sql` 包含 TRUNCATE 操作，**严禁在生产环境执行**
3. **性能测试**：数据量为演示级别，压测请自行扩展存储过程生成更多数据
4. **MySQL版本**：要求 8.0+（使用窗口函数、CTE递归、JSON类型等特性）

---

## 📖 ER关系简图

```
[supplier] --1:N--> [purchase_order] --1:N--> [purchase_order_item] --> [product_sku]
    |                                              |
    +--1:N--> [supplier_rating]                   +--> [purchase_in_stock]
    +--1:N--> [supplier_contract]

[customer] --1:N--> [sales_order] --1:N--> [sales_order_item] --> [product_sku]
    |                                         |
    +--N:1--> [customer_level]               +--> [sales_out_stock]

[product_spu] --1:N--> [product_sku] --1:N--> [product_price]
    |                    |
    +--N:1--> [category] +--1:N--> [product_barcode]
    +--N:1--> [brand]

[warehouse] --1:N--> [warehouse_location]
    |                    |
    +--1:N--> [inventory]+--N:1--> [inventory_log]

[carrier] --1:N--> [waybill] --1:N--> [logistics_track]
```

---

## 📝 版本记录

| 版本 | 日期 | 说明 |
|------|------|------|
| v1.0 | 2024 | 初始版本，含40张表 + 90道练习题 |

---

> 祝学习愉快！如有问题或建议，欢迎反馈。
