-- ============================================================
-- 企业级供应链中台系统 - DDL 建表脚本
-- 数据库: MySQL 8.0+
-- 字符集: utf8mb4
-- 引擎: InnoDB
-- 作者: Kimi Code
-- ============================================================

DROP DATABASE IF EXISTS scm_platform;
CREATE DATABASE scm_platform CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE scm_platform;

-- ============================================================
-- 1. 基础数据层 (Foundation)
-- ============================================================

-- 1.1 组织架构表
CREATE TABLE organization (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '组织ID',
    org_code        VARCHAR(32)         NOT NULL COMMENT '组织编码',
    org_name        VARCHAR(100)        NOT NULL COMMENT '组织名称',
    org_type        TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '组织类型: 1集团 2公司 3部门 4仓库',
    parent_id       BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '父组织ID, 0为顶级',
    level           TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '层级深度',
    path            VARCHAR(500)        NOT NULL DEFAULT '' COMMENT '组织路径, 如 /1/2/5/',
    leader_id       BIGINT UNSIGNED     DEFAULT NULL COMMENT '负责人用户ID',
    phone           VARCHAR(20)         DEFAULT NULL COMMENT '联系电话',
    email           VARCHAR(100)        DEFAULT NULL COMMENT '邮箱',
    address         VARCHAR(255)        DEFAULT NULL COMMENT '地址',
    sort_order      INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '排序',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '创建人ID',
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '更新人ID',
    deleted_at      DATETIME            DEFAULT NULL COMMENT '逻辑删除时间',
    version         INT UNSIGNED        NOT NULL DEFAULT 1 COMMENT '乐观锁版本号',
    remark          VARCHAR(500)        DEFAULT NULL COMMENT '备注',
    PRIMARY KEY (id),
    UNIQUE KEY uk_org_code (org_code) USING BTREE,
    KEY idx_parent_id (parent_id),
    KEY idx_org_type (org_type),
    KEY idx_path (path(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='组织架构表';


-- 1.2 用户表
CREATE TABLE sys_user (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '用户ID',
    username        VARCHAR(50)         NOT NULL COMMENT '用户名',
    password        VARCHAR(128)        NOT NULL COMMENT '密码(加密)',
    real_name       VARCHAR(50)         NOT NULL COMMENT '真实姓名',
    employee_no     VARCHAR(32)         DEFAULT NULL COMMENT '工号',
    org_id          BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '所属组织ID',
    dept_id         BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '部门ID',
    phone           VARCHAR(20)         DEFAULT NULL COMMENT '手机号',
    email           VARCHAR(100)        DEFAULT NULL COMMENT '邮箱',
    avatar          VARCHAR(255)        DEFAULT NULL COMMENT '头像URL',
    gender          TINYINT UNSIGNED    DEFAULT 0 COMMENT '性别: 0未知 1男 2女',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用 2锁定',
    last_login_time DATETIME            DEFAULT NULL COMMENT '最后登录时间',
    last_login_ip   VARCHAR(40)         DEFAULT NULL COMMENT '最后登录IP',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_username (username),
    UNIQUE KEY uk_employee_no (employee_no),
    KEY idx_org_id (org_id),
    KEY idx_dept_id (dept_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统用户表';

-- 1.3 角色表
CREATE TABLE sys_role (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '角色ID',
    role_code       VARCHAR(50)         NOT NULL COMMENT '角色编码',
    role_name       VARCHAR(50)         NOT NULL COMMENT '角色名称',
    role_type       TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '角色类型: 1系统角色 2业务角色 3数据角色',
    data_scope      TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '数据范围: 1全部 2本部门 3本部门及以下 4仅本人 5自定义',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_role_code (role_code),
    KEY idx_role_type (role_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='角色表';

-- 1.4 用户角色关联表
CREATE TABLE user_role (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    user_id         BIGINT UNSIGNED     NOT NULL COMMENT '用户ID',
    role_id         BIGINT UNSIGNED     NOT NULL COMMENT '角色ID',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_user_role (user_id, role_id),
    KEY idx_role_id (role_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='用户角色关联表';

-- 1.5 数据字典类型表
CREATE TABLE dict_type (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    dict_name       VARCHAR(50)         NOT NULL COMMENT '字典名称',
    dict_code       VARCHAR(50)         NOT NULL COMMENT '字典编码',
    description     VARCHAR(200)        DEFAULT NULL COMMENT '描述',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_dict_code (dict_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典类型表';

-- 1.6 数据字典数据表
CREATE TABLE dict_data (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    dict_type_id    BIGINT UNSIGNED     NOT NULL COMMENT '字典类型ID',
    dict_label      VARCHAR(50)         NOT NULL COMMENT '字典标签',
    dict_value      VARCHAR(100)        NOT NULL COMMENT '字典键值',
    sort_order      INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '排序',
    is_default      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否默认: 0否 1是',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_type_value (dict_type_id, dict_value),
    KEY idx_dict_type_id (dict_type_id),
    KEY idx_sort_order (sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='字典数据表';

-- 1.7 系统配置表
CREATE TABLE sys_config (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    config_key      VARCHAR(100)        NOT NULL COMMENT '配置键',
    config_value    TEXT                COMMENT '配置值',
    config_type     TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '配置类型: 1文本 2JSON 3数字 4布尔',
    description     VARCHAR(200)        DEFAULT NULL,
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_config_key (config_key)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='系统配置表';

-- ============================================================
-- 2. 商品中心 (Product Center)
-- ============================================================

-- 2.1 商品类目表
CREATE TABLE category (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '类目ID',
    category_code   VARCHAR(32)         NOT NULL COMMENT '类目编码',
    category_name   VARCHAR(100)        NOT NULL COMMENT '类目名称',
    parent_id       BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '父类目ID',
    level           TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '层级',
    path            VARCHAR(500)        NOT NULL DEFAULT '' COMMENT '类目路径',
    sort_order      INT UNSIGNED        NOT NULL DEFAULT 0,
    icon            VARCHAR(255)        DEFAULT NULL COMMENT '图标',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_category_code (category_code),
    KEY idx_parent_id (parent_id),
    KEY idx_level (level),
    KEY idx_path (path(100))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品类目表';

-- 2.2 品牌表
CREATE TABLE brand (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '品牌ID',
    brand_code      VARCHAR(32)         NOT NULL COMMENT '品牌编码',
    brand_name      VARCHAR(100)        NOT NULL COMMENT '品牌名称',
    brand_name_en   VARCHAR(100)        DEFAULT NULL COMMENT '品牌英文名称',
    logo_url        VARCHAR(255)        DEFAULT NULL COMMENT '品牌LOGO',
    website         VARCHAR(255)        DEFAULT NULL COMMENT '官网',
    description     VARCHAR(500)        DEFAULT NULL COMMENT '品牌描述',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_brand_code (brand_code),
    KEY idx_brand_name (brand_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='品牌表';

-- 2.3 商品SPU表
CREATE TABLE product_spu (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT 'SPU_ID',
    spu_code        VARCHAR(32)         NOT NULL COMMENT 'SPU编码',
    spu_name        VARCHAR(200)        NOT NULL COMMENT 'SPU名称',
    category_id     BIGINT UNSIGNED     NOT NULL COMMENT '类目ID',
    brand_id        BIGINT UNSIGNED     DEFAULT NULL COMMENT '品牌ID',
    unit            VARCHAR(20)         NOT NULL DEFAULT '件' COMMENT '计量单位',
    weight          DECIMAL(10,3)       DEFAULT NULL COMMENT '重量(kg)',
    volume          DECIMAL(10,4)       DEFAULT NULL COMMENT '体积(m³)',
    barcode         VARCHAR(50)         DEFAULT NULL COMMENT '主条码',
    spec_template   JSON                COMMENT '规格模板, 如 ["颜色","尺寸"]',
    description     TEXT                COMMENT '商品描述',
    main_image      VARCHAR(255)        DEFAULT NULL COMMENT '主图',
    images          JSON                COMMENT '图片列表',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1启用 2待审核',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_spu_code (spu_code),
    KEY idx_category_id (category_id),
    KEY idx_brand_id (brand_id),
    KEY idx_spu_name (spu_name),
    KEY idx_status (status),
    KEY idx_barcode (barcode),
    FULLTEXT KEY ft_spu_name (spu_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品SPU表';

-- 2.4 商品SKU表
CREATE TABLE product_sku (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT 'SKU_ID',
    sku_code        VARCHAR(32)         NOT NULL COMMENT 'SKU编码',
    spu_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SPU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    sku_specs       JSON                NOT NULL COMMENT '规格值, 如 {"颜色":"红色","尺寸":"XL"}',
    barcode         VARCHAR(50)         DEFAULT NULL COMMENT '主条码(冗余,详见product_barcode)',
    weight          DECIMAL(10,3)       DEFAULT NULL COMMENT '重量(kg)',
    volume          DECIMAL(10,4)       DEFAULT NULL COMMENT '体积(m³)',
    -- 以下价格为缓存字段，以 product_price 表中的有效价格为准
    cost_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '最新采购成本价(缓存)',
    sale_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '当前零售价(缓存)',
    market_price    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '市场指导价(缓存)',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1启用',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_sku_code (sku_code),
    KEY idx_spu_id (spu_id),
    KEY idx_barcode (barcode),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品SKU表';

-- 2.5 商品价格表
CREATE TABLE product_price (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    price_type      TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '价格类型: 1采购价 2批发价 3零售价 4会员价 5促销价',
    price           DECIMAL(18,4)       NOT NULL DEFAULT 0.0000,
    min_qty         DECIMAL(18,4)       NOT NULL DEFAULT 1.0000 COMMENT '最小数量',
    max_qty         DECIMAL(18,4)       DEFAULT NULL COMMENT '最大数量',
    effective_date  DATE                NOT NULL COMMENT '生效日期',
    expiry_date     DATE                DEFAULT NULL COMMENT '失效日期',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_sku_id (sku_id),
    KEY idx_price_type (price_type),
    KEY idx_effective_date (effective_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品价格表';

-- 2.6 商品条码表
CREATE TABLE product_barcode (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    barcode         VARCHAR(50)         NOT NULL COMMENT '条码',
    barcode_type    TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '条码类型: 1国标码 2店内码 3箱码 4托盘码',
    qty_ratio       DECIMAL(10,4)       NOT NULL DEFAULT 1.0000 COMMENT '换算比率(1箱=N件)',
    is_primary      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否主条码: 0否 1是',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_barcode_type (barcode, barcode_type),
    KEY idx_sku_id (sku_id),
    KEY idx_barcode_type (barcode_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='商品条码表';


-- ============================================================
-- 3. 供应商管理 (Supplier Management)
-- ============================================================

-- 3.1 供应商档案表
CREATE TABLE supplier (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '供应商ID',
    supplier_code   VARCHAR(32)         NOT NULL COMMENT '供应商编码',
    supplier_name   VARCHAR(100)        NOT NULL COMMENT '供应商名称',
    supplier_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '供应商类型: 1制造商 2经销商 3代理商 4物流商',
    credit_level    TINYINT UNSIGNED    NOT NULL DEFAULT 3 COMMENT '信用等级: 1-5星',
    cooperate_status TINYINT UNSIGNED   NOT NULL DEFAULT 1 COMMENT '合作状态: 0停用 1合作中 2黑名单 3潜在',
    -- 以下联系人字段为首要联系人冗余缓存，详细联系人见 supplier_contact 表
    contact_name    VARCHAR(50)         DEFAULT NULL COMMENT '首要联系人(冗余缓存)',
    contact_phone   VARCHAR(20)         DEFAULT NULL COMMENT '首要联系人电话(冗余缓存)',
    contact_email   VARCHAR(100)        DEFAULT NULL COMMENT '首要联系人邮箱(冗余缓存)',
    province        VARCHAR(50)         DEFAULT NULL COMMENT '省份',
    city            VARCHAR(50)         DEFAULT NULL COMMENT '城市',
    district        VARCHAR(50)         DEFAULT NULL COMMENT '区县',
    address         VARCHAR(255)        DEFAULT NULL COMMENT '详细地址',
    bank_name       VARCHAR(100)        DEFAULT NULL COMMENT '开户银行',
    bank_account    VARCHAR(50)         DEFAULT NULL COMMENT '银行账号',
    tax_no          VARCHAR(50)         DEFAULT NULL COMMENT '税号',
    registered_capital DECIMAL(18,2)    DEFAULT NULL COMMENT '注册资本(万元)',
    establish_date  DATE                DEFAULT NULL COMMENT '成立日期',
    legal_person    VARCHAR(50)         DEFAULT NULL COMMENT '法人',
    business_scope  VARCHAR(500)        DEFAULT NULL COMMENT '经营范围',
    audit_status    TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '审核状态: 0待审核 1已通过 2已拒绝',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_supplier_code (supplier_code),
    KEY idx_supplier_name (supplier_name),
    KEY idx_supplier_type (supplier_type),
    KEY idx_credit_level (credit_level),
    KEY idx_cooperate_status (cooperate_status),
    KEY idx_audit_status (audit_status),
    KEY idx_province_city (province, city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商档案表';

-- 3.2 供应商联系人表
CREATE TABLE supplier_contact (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    contact_name    VARCHAR(50)         NOT NULL COMMENT '联系人姓名',
    position        VARCHAR(50)         DEFAULT NULL COMMENT '职位',
    phone           VARCHAR(20)         DEFAULT NULL COMMENT '电话',
    email           VARCHAR(100)        DEFAULT NULL COMMENT '邮箱',
    wechat          VARCHAR(50)         DEFAULT NULL COMMENT '微信',
    is_primary      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否首要联系人',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_is_primary (is_primary)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商联系人表';

-- 3.3 供应商评级表
CREATE TABLE supplier_rating (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    rating_period   VARCHAR(20)         NOT NULL COMMENT '评级周期, 如 2024-Q1',
    quality_score   DECIMAL(4,2)        NOT NULL DEFAULT 0.00 COMMENT '质量评分(0-100)',
    delivery_score  DECIMAL(4,2)        NOT NULL DEFAULT 0.00 COMMENT '交付评分(0-100)',
    service_score   DECIMAL(4,2)        NOT NULL DEFAULT 0.00 COMMENT '服务评分(0-100)',
    price_score     DECIMAL(4,2)        NOT NULL DEFAULT 0.00 COMMENT '价格评分(0-100)',
    total_score     DECIMAL(4,2)        NOT NULL DEFAULT 0.00 COMMENT '综合评分',
    rating_level    TINYINT UNSIGNED    NOT NULL DEFAULT 3 COMMENT '评级等级: 1-5星',
    evaluator_id    BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '评估人ID',
    evaluate_date   DATE                NOT NULL COMMENT '评估日期',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_rating_period (rating_period),
    KEY idx_rating_level (rating_level)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商评级表';

-- 3.4 供应商合同表
CREATE TABLE supplier_contract (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    contract_no     VARCHAR(50)         NOT NULL COMMENT '合同编号',
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    contract_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '合同类型: 1采购合同 2框架协议 3物流合同',
    contract_name   VARCHAR(100)        NOT NULL COMMENT '合同名称',
    start_date      DATE                NOT NULL COMMENT '生效日期',
    end_date        DATE                NOT NULL COMMENT '到期日期',
    amount_limit    DECIMAL(18,2)       DEFAULT NULL COMMENT '金额上限',
    payment_terms   VARCHAR(200)        DEFAULT NULL COMMENT '付款条款',
    delivery_terms  VARCHAR(200)        DEFAULT NULL COMMENT '交付条款',
    penalty_clause  VARCHAR(500)        DEFAULT NULL COMMENT '违约条款',
    attachment_url  VARCHAR(255)        DEFAULT NULL COMMENT '合同附件',
    sign_date       DATE                DEFAULT NULL COMMENT '签订日期',
    signatory       VARCHAR(50)         DEFAULT NULL COMMENT '签订人',
    audit_status    TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '审核状态',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0草稿 1生效 2到期 3终止',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_contract_no (contract_no),
    KEY idx_supplier_id (supplier_id),
    KEY idx_contract_type (contract_type),
    KEY idx_start_date (start_date),
    KEY idx_end_date (end_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商合同表';

-- 3.5 供应商商品目录表
CREATE TABLE supplier_product (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    supplier_sku_code VARCHAR(64)       DEFAULT NULL COMMENT '供应商SKU编码',
    supplier_sku_name VARCHAR(200)      DEFAULT NULL COMMENT '供应商SKU名称',
    purchase_price  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '采购价',
    tax_rate        DECIMAL(5,2)        NOT NULL DEFAULT 13.00 COMMENT '税率(%)',
    min_order_qty   DECIMAL(18,4)       NOT NULL DEFAULT 1.0000 COMMENT '最小起订量',
    lead_time_days  INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '交货周期(天)',
    is_primary      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否首选供应商: 0否 1是',
    effective_date  DATE                NOT NULL COMMENT '价格生效日期',
    expiry_date     DATE                DEFAULT NULL COMMENT '价格失效日期',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1启用',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_supplier_sku (supplier_id, sku_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_sku_id (sku_id),
    KEY idx_is_primary (is_primary),
    KEY idx_effective_date (effective_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='供应商商品目录表';

-- ============================================================
-- 4. 采购管理 (Procurement)
-- ============================================================

-- 4.1 采购申请表
CREATE TABLE purchase_request (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    request_no      VARCHAR(32)         NOT NULL COMMENT '申请单号',
    org_id          BIGINT UNSIGNED     NOT NULL COMMENT '申请组织ID',
    requester_id    BIGINT UNSIGNED     NOT NULL COMMENT '申请人ID',
    request_date    DATE                NOT NULL COMMENT '申请日期',
    expect_date     DATE                DEFAULT NULL COMMENT '期望到货日期',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总金额',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY' COMMENT '币种',
    priority        TINYINT UNSIGNED    NOT NULL DEFAULT 2 COMMENT '紧急程度: 1紧急 2普通 3低',
    approval_status TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '审批状态: 0待审批 1审批中 2已通过 3已拒绝',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0作废 1待处理 2已转采购 3部分采购 4已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_request_no (request_no),
    KEY idx_org_id (org_id),
    KEY idx_requester_id (requester_id),
    KEY idx_request_date (request_date),
    KEY idx_approval_status (approval_status),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购申请表';

-- 4.2 采购申请明细表
CREATE TABLE purchase_request_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    request_id      BIGINT UNSIGNED     NOT NULL COMMENT '申请单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    qty             DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '申请数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '预估单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '预估金额',
    reason          VARCHAR(255)        DEFAULT NULL COMMENT '申请原因',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待处理 2已转采购',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_request_id (request_id),
    KEY idx_sku_id (sku_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购申请明细表';

-- 4.3 采购订单表
CREATE TABLE purchase_order (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    order_no        VARCHAR(32)         NOT NULL COMMENT '采购订单号',
    request_id      BIGINT UNSIGNED     DEFAULT NULL COMMENT '关联申请单ID',
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    org_id          BIGINT UNSIGNED     NOT NULL COMMENT '采购组织ID',
    buyer_id        BIGINT UNSIGNED     NOT NULL COMMENT '采购员ID',
    order_date      DATE                NOT NULL COMMENT '下单日期',
    expect_date     DATE                DEFAULT NULL COMMENT '预计到货日期',
    arrive_date     DATE                DEFAULT NULL COMMENT '实际到货日期',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '订单总金额',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '订单总数量',
    discount_amount DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '折扣金额',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    payable_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应付金额',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    payment_terms   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '付款条件: 1预付 2货到付款 3月结 4账期',
    payment_days    INT UNSIGNED        DEFAULT NULL COMMENT '账期天数',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '入库仓库ID',
    delivery_address VARCHAR(255)       DEFAULT NULL COMMENT '送货地址',
    receive_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '收货状态: 0未收货 1部分收货 2全部收货',
    pay_status      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '付款状态: 0未付款 1部分付款 2全部付款',
    invoice_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '开票状态: 0未开票 1部分开票 2全部开票',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待确认 2已确认 3已到货 4已关闭',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_request_id (request_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_org_id (org_id),
    KEY idx_buyer_id (buyer_id),
    KEY idx_order_date (order_date),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_status (status),
    KEY idx_expect_date (expect_date),
    KEY idx_pay_status (pay_status),
    KEY idx_invoice_status (invoice_status),
    KEY idx_receive_status (receive_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购订单表';

-- 4.4 采购订单明细表
CREATE TABLE purchase_order_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '采购订单ID',
    request_item_id BIGINT UNSIGNED     DEFAULT NULL COMMENT '关联申请明细ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    sku_specs       JSON                DEFAULT NULL COMMENT '规格快照',
    qty             DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '采购数量',
    received_qty    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已收货数量',
    returned_qty    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已退货数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '采购单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    tax_rate        DECIMAL(5,2)        NOT NULL DEFAULT 13.00 COMMENT '税率(%)',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    discount_rate   DECIMAL(5,2)        NOT NULL DEFAULT 0.00 COMMENT '折扣率(%)',
    delivery_date   DATE                DEFAULT NULL COMMENT '预计交货日期',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待收货 2部分收货 3全部收货',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_order_id (order_id),
    KEY idx_sku_id (sku_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购订单明细表';

-- 4.5 采购入库表
CREATE TABLE purchase_in_stock (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    in_stock_no     VARCHAR(32)         NOT NULL COMMENT '入库单号',
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '关联采购订单ID',
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '入库仓库ID',
    operator_id     BIGINT UNSIGNED     NOT NULL COMMENT '操作人ID',
    in_stock_date   DATE                NOT NULL COMMENT '入库日期',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '入库总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '入库总金额',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0作废 1待审核 2已审核 3已入库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_in_stock_no (in_stock_no),
    KEY idx_order_id (order_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_in_stock_date (in_stock_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购入库表';

-- 4.5.1 采购入库明细表
CREATE TABLE purchase_in_stock_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    in_stock_id     BIGINT UNSIGNED     NOT NULL COMMENT '入库单ID',
    order_item_id   BIGINT UNSIGNED     NOT NULL COMMENT '关联采购订单明细ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称快照',
    sku_specs       JSON                DEFAULT NULL COMMENT '规格快照',
    expect_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应收数量',
    actual_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实收数量',
    qualified_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '合格数量',
    unqualified_qty DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '不合格数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '采购单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '上架库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    production_date DATE                DEFAULT NULL COMMENT '生产日期',
    expiry_date     DATE                DEFAULT NULL COMMENT '有效期至',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待收货 2已收货 3已上架',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_in_stock_id (in_stock_id),
    KEY idx_order_item_id (order_item_id),
    KEY idx_sku_id (sku_id),
    KEY idx_location_id (location_id),
    KEY idx_batch_no (batch_no),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购入库明细表';

-- 4.6 采购退货表
CREATE TABLE purchase_return (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    return_no       VARCHAR(32)         NOT NULL COMMENT '退货单号',
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '关联采购订单ID',
    in_stock_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '关联入库单ID',
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '退货仓库ID',
    operator_id     BIGINT UNSIGNED     NOT NULL COMMENT '操作人ID',
    return_date     DATE                NOT NULL COMMENT '退货日期',
    return_reason   VARCHAR(255)        NOT NULL COMMENT '退货原因',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货总金额',
    refund_status   TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '退款状态: 0未退款 1已退款',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待审核 2已审核 3已退货',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_return_no (return_no),
    KEY idx_order_id (order_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_return_date (return_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购退货表';

-- 4.6.1 采购退货明细表
CREATE TABLE purchase_return_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    return_id       BIGINT UNSIGNED     NOT NULL COMMENT '退货单ID',
    order_item_id   BIGINT UNSIGNED     NOT NULL COMMENT '关联采购订单明细ID',
    in_stock_item_id BIGINT UNSIGNED    DEFAULT NULL COMMENT '关联入库明细ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称快照',
    sku_specs       JSON                DEFAULT NULL COMMENT '规格快照',
    return_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货金额',
    return_reason   VARCHAR(255)        DEFAULT NULL COMMENT '明细退货原因',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待退货 2已退货',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_return_id (return_id),
    KEY idx_order_item_id (order_item_id),
    KEY idx_sku_id (sku_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='采购退货明细表';

-- ============================================================
-- 5. 库存管理 (Inventory Management)
-- ============================================================

-- 5.1 仓库表
CREATE TABLE warehouse (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '仓库ID',
    warehouse_code  VARCHAR(32)         NOT NULL COMMENT '仓库编码',
    warehouse_name  VARCHAR(100)        NOT NULL COMMENT '仓库名称',
    warehouse_type  TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '仓库类型: 1中心仓 2区域仓 3前置仓 4保税仓 5退货仓',
    org_id          BIGINT UNSIGNED     NOT NULL COMMENT '所属组织ID',
    province        VARCHAR(50)         DEFAULT NULL,
    city            VARCHAR(50)         DEFAULT NULL,
    district        VARCHAR(50)         DEFAULT NULL,
    address         VARCHAR(255)        DEFAULT NULL,
    contact_name    VARCHAR(50)         DEFAULT NULL,
    contact_phone   VARCHAR(20)         DEFAULT NULL,
    area_sqm        DECIMAL(10,2)       DEFAULT NULL COMMENT '面积(m²)',
    capacity_volume DECIMAL(12,4)       DEFAULT NULL COMMENT '容量(m³)',
    is_default      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否默认仓',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_warehouse_code (warehouse_code),
    KEY idx_org_id (org_id),
    KEY idx_warehouse_type (warehouse_type),
    KEY idx_province_city (province, city),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='仓库表';

-- 5.2 库位表
CREATE TABLE warehouse_location (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    location_code   VARCHAR(32)         NOT NULL COMMENT '库位编码',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    zone_code       VARCHAR(20)         NOT NULL COMMENT '库区编码',
    aisle_code      VARCHAR(20)         DEFAULT NULL COMMENT '巷道编码',
    shelf_code      VARCHAR(20)         DEFAULT NULL COMMENT '货架编码',
    layer_no        TINYINT UNSIGNED    DEFAULT NULL COMMENT '层号',
    position_no     VARCHAR(20)         DEFAULT NULL COMMENT '位号',
    location_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '库位类型: 1拣货位 2存储位 3暂存位 4退货位 5不良品位',
    max_weight      DECIMAL(10,3)       DEFAULT NULL COMMENT '最大承重(kg)',
    max_volume      DECIMAL(10,4)       DEFAULT NULL COMMENT '最大容积(m³)',
    is_empty        TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '是否空闲: 0占用 1空闲',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_location_code (location_code),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_zone_code (zone_code),
    KEY idx_location_type (location_type),
    KEY idx_is_empty (is_empty)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库位表';

-- 5.3 库存台账表 (SKU+仓库维度汇总，批次明细见 inventory_batch)
CREATE TABLE inventory (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    available_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '可用库存(汇总)',
    frozen_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '冻结库存',
    locked_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '锁定库存',
    on_way_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '在途库存',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总库存',
    safety_stock    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '安全库存',
    max_stock       DECIMAL(18,4)       DEFAULT NULL COMMENT '最大库存',
    cost_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '移动平均成本',
    total_cost      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总成本',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_sku_warehouse (sku_id, warehouse_id),
    KEY idx_sku_id (sku_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_warehouse_available (warehouse_id, available_qty),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存台账表';

-- 5.4 库存流水表 (按时间分区预留)
CREATE TABLE inventory_log (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    log_no          VARCHAR(32)         NOT NULL COMMENT '流水号',
    business_type   TINYINT UNSIGNED    NOT NULL COMMENT '业务类型: 1采购入库 2采购退货 3销售出库 4销售退货 5调拨入库 6调拨出库 7盘点盈亏 8其他入库 9其他出库',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    before_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动前数量',
    change_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动数量(正入负出)',
    after_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动后数量',
    before_cost     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动前成本',
    change_cost     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动成本',
    after_cost      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '变动后成本',
    operator_id     BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '操作人ID',
    operation_time  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id, operation_time),
    UNIQUE KEY uk_log_no (log_no, operation_time),
    KEY idx_business_type (business_type),
    KEY idx_business_no (business_no),
    KEY idx_sku_id (sku_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_operation_time (operation_time),
    KEY idx_batch_no (batch_no)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存流水表'
PARTITION BY RANGE COLUMNS(operation_time) (
    PARTITION p2023 VALUES LESS THAN ('2024-01-01'),
    PARTITION p2024 VALUES LESS THAN ('2025-01-01'),
    PARTITION p2025 VALUES LESS THAN ('2026-01-01'),
    PARTITION p2026 VALUES LESS THAN ('2027-01-01'),
    PARTITION pfuture VALUES LESS THAN MAXVALUE
);

-- 5.5 库存盘点表
CREATE TABLE stock_take (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    take_no         VARCHAR(32)         NOT NULL COMMENT '盘点单号',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    take_type       TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '盘点类型: 1全盘 2抽盘 3动销盘 4临时盘',
    take_method     TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '盘点方式: 1静态盘点 2动态盘点',
    plan_date       DATE                NOT NULL COMMENT '计划盘点日期',
    actual_date     DATE                DEFAULT NULL COMMENT '实际盘点日期',
    operator_id     BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '盘点人ID',
    checker_id      BIGINT UNSIGNED     DEFAULT NULL COMMENT '复盘人ID',
    total_sku_count INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU总数',
    diff_sku_count  INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '差异SKU数',
    profit_amount   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '盘盈金额',
    loss_amount     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '盘亏金额',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待盘点 2盘点中 3待审核 4已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_take_no (take_no),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_plan_date (plan_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存盘点表';

-- 5.6 库存盘点明细表
CREATE TABLE stock_take_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    take_id         BIGINT UNSIGNED     NOT NULL COMMENT '盘点单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    book_qty        DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '账面数量',
    actual_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实盘数量',
    diff_qty        DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '差异数量',
    unit_cost       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '单位成本',
    diff_amount     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '差异金额',
    reason          VARCHAR(255)        DEFAULT NULL COMMENT '差异原因',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0待盘 1已盘 2已调整',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_take_id (take_id),
    KEY idx_sku_id (sku_id),
    KEY idx_location_id (location_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存盘点明细表';

-- 5.7 库存调拨表
CREATE TABLE stock_transfer (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    transfer_no     VARCHAR(32)         NOT NULL COMMENT '调拨单号',
    from_warehouse_id BIGINT UNSIGNED   NOT NULL COMMENT '调出仓库ID',
    to_warehouse_id BIGINT UNSIGNED     NOT NULL COMMENT '调入仓库ID',
    transfer_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '调拨类型: 1同城调拨 2跨区调拨 3退货调拨 4补货调拨',
    apply_id        BIGINT UNSIGNED     NOT NULL COMMENT '申请人ID',
    apply_date      DATE                NOT NULL COMMENT '申请日期',
    ship_date       DATE                DEFAULT NULL COMMENT '发货日期',
    receive_date    DATE                DEFAULT NULL COMMENT '收货日期',
    carrier_id      BIGINT UNSIGNED     DEFAULT NULL COMMENT '承运商ID',
    waybill_no      VARCHAR(50)         DEFAULT NULL COMMENT '运单号',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总金额',
    ship_status     TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '发货状态: 0未发货 1部分发货 2全部发货',
    receive_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '收货状态: 0未收货 1部分收货 2全部收货',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待审核 2已审核 3已出库 4运输中 5已入库 6已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_transfer_no (transfer_no),
    KEY idx_from_warehouse_id (from_warehouse_id),
    KEY idx_to_warehouse_id (to_warehouse_id),
    KEY idx_apply_date (apply_date),
    KEY idx_carrier_id (carrier_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存调拨表';

-- 5.8 库存调拨明细表
CREATE TABLE stock_transfer_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    transfer_id     BIGINT UNSIGNED     NOT NULL COMMENT '调拨单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    from_location_id BIGINT UNSIGNED    DEFAULT NULL COMMENT '调出库位ID',
    to_location_id  BIGINT UNSIGNED     DEFAULT NULL COMMENT '调入库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    transfer_qty    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '调拨数量',
    shipped_qty     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已发货数量',
    received_qty    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已收货数量',
    unit_cost       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '单位成本',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待出库 2已出库 3已入库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_transfer_id (transfer_id),
    KEY idx_sku_id (sku_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存调拨明细表';

-- ============================================================
-- 6. 销售管理 (Sales Management)
-- ============================================================

-- 6.1 客户等级表
CREATE TABLE customer_level (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    level_code      VARCHAR(32)         NOT NULL COMMENT '等级编码',
    level_name      VARCHAR(50)         NOT NULL COMMENT '等级名称',
    min_amount      DECIMAL(18,2)       NOT NULL DEFAULT 0.00 COMMENT '最低消费金额',
    max_amount      DECIMAL(18,2)       DEFAULT NULL COMMENT '最高消费金额',
    discount_rate   DECIMAL(5,2)        NOT NULL DEFAULT 100.00 COMMENT '折扣率(%)',
    credit_limit    DECIMAL(18,2)       DEFAULT NULL COMMENT '信用额度',
    credit_days     INT UNSIGNED        DEFAULT NULL COMMENT '信用天数',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_level_code (level_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户等级表';

-- 6.2 客户档案表
CREATE TABLE customer (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT COMMENT '客户ID',
    customer_code   VARCHAR(32)         NOT NULL COMMENT '客户编码',
    customer_name   VARCHAR(100)        NOT NULL COMMENT '客户名称',
    customer_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '客户类型: 1企业 2个人 3经销商 4电商',
    level_id        BIGINT UNSIGNED     NOT NULL DEFAULT 1 COMMENT '客户等级ID',
    credit_limit    DECIMAL(18,2)       DEFAULT NULL COMMENT '信用额度',
    credit_used     DECIMAL(18,2)       NOT NULL DEFAULT 0.00 COMMENT '已用信用额度',
    credit_days     INT UNSIGNED        DEFAULT NULL COMMENT '账期天数',
    contact_name    VARCHAR(50)         DEFAULT NULL COMMENT '联系人',
    contact_phone   VARCHAR(20)         DEFAULT NULL COMMENT '联系人电话',
    contact_email   VARCHAR(100)        DEFAULT NULL COMMENT '联系人邮箱',
    province        VARCHAR(50)         DEFAULT NULL,
    city            VARCHAR(50)         DEFAULT NULL,
    district        VARCHAR(50)         DEFAULT NULL,
    address         VARCHAR(255)        DEFAULT NULL,
    tax_no          VARCHAR(50)         DEFAULT NULL COMMENT '税号',
    bank_name       VARCHAR(100)        DEFAULT NULL,
    bank_account    VARCHAR(50)         DEFAULT NULL,
    sales_rep_id    BIGINT UNSIGNED     DEFAULT NULL COMMENT '销售代表ID',
    first_deal_date DATE                DEFAULT NULL COMMENT '首次交易日期',
    -- 以下统计字段为缓存，实时统计数据见 customer_stat 表，避免高并发热点更新
    last_deal_date  DATE                DEFAULT NULL COMMENT '最后交易日期(缓存)',
    total_deal_amount DECIMAL(18,2)     NOT NULL DEFAULT 0.00 COMMENT '累计交易金额(缓存)',
    total_deal_count INT UNSIGNED       NOT NULL DEFAULT 0 COMMENT '累计交易次数(缓存)',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0停用 1启用 2黑名单',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_customer_code (customer_code),
    KEY idx_customer_name (customer_name),
    KEY idx_customer_type (customer_type),
    KEY idx_level_id (level_id),
    KEY idx_sales_rep_id (sales_rep_id),
    KEY idx_status (status),
    KEY idx_province_city (province, city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户档案表';

-- 6.3 销售订单表
CREATE TABLE sales_order (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    order_no        VARCHAR(32)         NOT NULL COMMENT '销售订单号',
    customer_id     BIGINT UNSIGNED     NOT NULL COMMENT '客户ID',
    sales_rep_id    BIGINT UNSIGNED     DEFAULT NULL COMMENT '销售代表ID',
    org_id          BIGINT UNSIGNED     NOT NULL COMMENT '销售组织ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '发货仓库ID',
    order_date      DATE                NOT NULL COMMENT '下单日期',
    expect_date     DATE                DEFAULT NULL COMMENT '期望交货日期',
    delivery_date   DATE                DEFAULT NULL COMMENT '实际发货日期',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '订单总金额',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '订单总数量',
    discount_amount DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '折扣金额',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    payable_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应收金额',
    paid_amount     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已收金额',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    delivery_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '配送方式: 1快递 2物流 3自提 4专车',
    delivery_address VARCHAR(255)       DEFAULT NULL COMMENT '收货地址',
    receiver_name   VARCHAR(50)         DEFAULT NULL COMMENT '收货人',
    receiver_phone  VARCHAR(20)         DEFAULT NULL COMMENT '收货电话',
    delivery_status TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '发货状态: 0未发货 1部分发货 2全部发货',
    pay_status      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '付款状态: 0未付款 1部分付款 2全部付款',
    invoice_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '开票状态: 0未开票 1部分开票 2全部开票',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待确认 2已确认 3已发货 4已完成 5已关闭',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_order_no (order_no),
    KEY idx_customer_id (customer_id),
    KEY idx_sales_rep_id (sales_rep_id),
    KEY idx_org_id (org_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_order_date (order_date),
    KEY idx_status (status),
    KEY idx_expect_date (expect_date),
    KEY idx_pay_status (pay_status),
    KEY idx_invoice_status (invoice_status),
    KEY idx_delivery_status (delivery_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售订单表';

-- 6.4 销售订单明细表
CREATE TABLE sales_order_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '销售订单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称快照',
    sku_specs       JSON                DEFAULT NULL COMMENT '规格快照',
    qty             DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '销售数量',
    delivered_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已发货数量',
    returned_qty    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已退货数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '销售单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    tax_rate        DECIMAL(5,2)        NOT NULL DEFAULT 13.00 COMMENT '税率(%)',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    discount_rate   DECIMAL(5,2)        NOT NULL DEFAULT 0.00 COMMENT '折扣率(%)',
    warehouse_id    BIGINT UNSIGNED     DEFAULT NULL COMMENT '指定发货仓库',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待发货 2部分发货 3全部发货',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_order_id (order_id),
    KEY idx_sku_id (sku_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售订单明细表';

-- 6.5 销售出库表
CREATE TABLE sales_out_stock (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    out_stock_no    VARCHAR(32)         NOT NULL COMMENT '出库单号',
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '关联销售订单ID',
    customer_id     BIGINT UNSIGNED     NOT NULL COMMENT '客户ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '出库仓库ID',
    operator_id     BIGINT UNSIGNED     NOT NULL COMMENT '操作人ID',
    out_stock_date  DATE                NOT NULL COMMENT '出库日期',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '出库总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '出库总金额',
    waybill_no      VARCHAR(50)         DEFAULT NULL COMMENT '运单号',
    carrier_id      BIGINT UNSIGNED     DEFAULT NULL COMMENT '承运商ID',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0作废 1待审核 2已审核 3已出库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_out_stock_no (out_stock_no),
    KEY idx_order_id (order_id),
    KEY idx_customer_id (customer_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_out_stock_date (out_stock_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售出库表';

-- 6.6 销售退货表
CREATE TABLE sales_return (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    return_no       VARCHAR(32)         NOT NULL COMMENT '退货单号',
    order_id        BIGINT UNSIGNED     NOT NULL COMMENT '关联销售订单ID',
    out_stock_id    BIGINT UNSIGNED     DEFAULT NULL COMMENT '关联出库单ID',
    customer_id     BIGINT UNSIGNED     NOT NULL COMMENT '客户ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '退货入库仓库ID',
    operator_id     BIGINT UNSIGNED     NOT NULL COMMENT '操作人ID',
    return_date     DATE                NOT NULL COMMENT '退货日期',
    return_reason   VARCHAR(255)        NOT NULL COMMENT '退货原因',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货总金额',
    refund_status   TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '退款状态: 0未退款 1已退款',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待审核 2已审核 3已入库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_return_no (return_no),
    KEY idx_order_id (order_id),
    KEY idx_customer_id (customer_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_return_date (return_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售退货表';

-- 6.6.1 销售退货明细表
CREATE TABLE sales_return_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    return_id       BIGINT UNSIGNED     NOT NULL COMMENT '退货单ID',
    order_item_id   BIGINT UNSIGNED     NOT NULL COMMENT '关联销售订单明细ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称快照',
    sku_specs       JSON                DEFAULT NULL COMMENT '规格快照',
    return_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '退货金额',
    tax_rate        DECIMAL(5,2)        NOT NULL DEFAULT 13.00 COMMENT '税率(%)',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    return_reason   VARCHAR(255)        DEFAULT NULL COMMENT '明细退货原因',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    warehouse_id    BIGINT UNSIGNED     DEFAULT NULL COMMENT '退货入库仓库ID',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '退货入库库位ID',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待退货 2已退货 3已入库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_return_id (return_id),
    KEY idx_order_item_id (order_item_id),
    KEY idx_sku_id (sku_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='销售退货明细表';


-- ============================================================
-- 7. 仓储作业 (WMS)
-- ============================================================

-- 7.1 入库单表
CREATE TABLE wms_inbound (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    inbound_no      VARCHAR(32)         NOT NULL COMMENT '入库单号',
    inbound_type    TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '入库类型: 1采购入库 2退货入库 3调拨入库 4其他入库',
    source_type     TINYINT UNSIGNED    NOT NULL COMMENT '来源类型: 1采购入库单 2销售退货单 3调拨单',
    source_id       BIGINT UNSIGNED     NOT NULL COMMENT '来源单据ID',
    source_no       VARCHAR(32)         NOT NULL COMMENT '来源单号',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    supplier_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '供应商ID(采购入库)',
    total_sku_count INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU种类数',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总金额',
    arrival_date    DATE                DEFAULT NULL COMMENT '预计到仓日期',
    actual_date     DATE                DEFAULT NULL COMMENT '实际到仓日期',
    operator_id     BIGINT UNSIGNED     NOT NULL DEFAULT 0 COMMENT '操作人ID',
    quality_check_status TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '质检状态: 0未质检 1质检中 2通过 3不通过',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待收货 2收货中 3待质检 4已质检 5已上架 6已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_inbound_no (inbound_no),
    KEY idx_inbound_type (inbound_type),
    KEY idx_source_no (source_no),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_status (status),
    KEY idx_actual_date (actual_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库单表';

-- 7.2 入库单明细表
CREATE TABLE wms_inbound_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    inbound_id      BIGINT UNSIGNED     NOT NULL COMMENT '入库单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    expect_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '预期数量',
    actual_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实收数量',
    qualified_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '合格数量',
    unqualified_qty DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '不合格数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '上架库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    production_date DATE                DEFAULT NULL COMMENT '生产日期',
    expiry_date     DATE                DEFAULT NULL COMMENT '有效期至',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待收货 2已收货 3已上架',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_inbound_id (inbound_id),
    KEY idx_sku_id (sku_id),
    KEY idx_location_id (location_id),
    KEY idx_batch_no (batch_no),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='入库单明细表';

-- 7.3 出库单表
CREATE TABLE wms_outbound (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    outbound_no     VARCHAR(32)         NOT NULL COMMENT '出库单号',
    outbound_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '出库类型: 1销售出库 2调拨出库 3退货出库 4其他出库',
    source_type     TINYINT UNSIGNED    NOT NULL COMMENT '来源类型: 1销售订单 2调拨单 3采购退货单',
    source_id       BIGINT UNSIGNED     NOT NULL COMMENT '来源单据ID',
    source_no       VARCHAR(32)         NOT NULL COMMENT '来源单号',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    customer_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '客户ID(销售出库)',
    total_sku_count INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU种类数',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总金额',
    priority        TINYINT UNSIGNED    NOT NULL DEFAULT 2 COMMENT '优先级: 1加急 2普通 3低',
    wave_id         BIGINT UNSIGNED     DEFAULT NULL COMMENT '所属波次ID',
    pick_status     TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '拣货状态: 0未拣货 1拣货中 2已拣货',
    pack_status     TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '打包状态: 0未打包 1已打包',
    ship_status     TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '发货状态: 0未发货 1已发货',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待分配 2待拣货 3拣货中 4待复核 5待打包 6待发货 7已发货 8已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_outbound_no (outbound_no),
    KEY idx_outbound_type (outbound_type),
    KEY idx_source_no (source_no),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_customer_id (customer_id),
    KEY idx_wave_id (wave_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='出库单表';

-- 7.4 出库单明细表
CREATE TABLE wms_outbound_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    outbound_id     BIGINT UNSIGNED     NOT NULL COMMENT '出库单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    expect_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应出数量',
    actual_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实出数量',
    unit_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '单价',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '出库库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待拣货 2已拣货 3已复核 4已出库',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_outbound_id (outbound_id),
    KEY idx_sku_id (sku_id),
    KEY idx_location_id (location_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='出库单明细表';

-- 7.5 波次表
CREATE TABLE wave (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    wave_no         VARCHAR(32)         NOT NULL COMMENT '波次号',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    wave_type       TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '波次类型: 1普通波次 2快递波次 3大宗波次',
    order_count     INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '订单数',
    sku_count       INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU种类数',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    start_time      DATETIME            DEFAULT NULL COMMENT '开始时间',
    end_time        DATETIME            DEFAULT NULL COMMENT '结束时间',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待执行 2执行中 3已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_wave_no (wave_no),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_wave_type (wave_type),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='波次表';

-- 7.6 拣货单表
CREATE TABLE pick_order (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    pick_no         VARCHAR(32)         NOT NULL COMMENT '拣货单号',
    wave_id         BIGINT UNSIGNED     NOT NULL COMMENT '波次ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    pick_type       TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '拣货类型: 1摘果式 2播种式 3边拣边分',
    picker_id       BIGINT UNSIGNED     DEFAULT NULL COMMENT '拣货人ID',
    start_time      DATETIME            DEFAULT NULL COMMENT '开始时间',
    end_time        DATETIME            DEFAULT NULL COMMENT '结束时间',
    sku_count       INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU种类数',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '总数量',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待拣货 2拣货中 3已拣货 4已复核',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_pick_no (pick_no),
    KEY idx_wave_id (wave_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_picker_id (picker_id),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拣货单表';

-- 7.7 拣货明细表
CREATE TABLE pick_order_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    pick_id         BIGINT UNSIGNED     NOT NULL COMMENT '拣货单ID',
    outbound_id     BIGINT UNSIGNED     NOT NULL COMMENT '出库单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称',
    location_id     BIGINT UNSIGNED     NOT NULL COMMENT '库位ID',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    expect_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应拣数量',
    actual_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实拣数量',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0缺货 1待拣 2已拣',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_pick_id (pick_id),
    KEY idx_outbound_id (outbound_id),
    KEY idx_sku_id (sku_id),
    KEY idx_location_id (location_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='拣货明细表';

-- ============================================================
-- 8. 物流管理 (TMS)
-- ============================================================

-- 8.1 承运商表
CREATE TABLE carrier (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    carrier_code    VARCHAR(32)         NOT NULL COMMENT '承运商编码',
    carrier_name    VARCHAR(100)        NOT NULL COMMENT '承运商名称',
    carrier_type    TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '承运商类型: 1快递 2物流 3专线 4冷链 5同城配送',
    contact_name    VARCHAR(50)         DEFAULT NULL COMMENT '联系人',
    contact_phone   VARCHAR(20)         DEFAULT NULL COMMENT '联系电话',
    api_config      JSON                DEFAULT NULL COMMENT '接口配置',
    is_default      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否默认',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_carrier_code (carrier_code),
    KEY idx_carrier_type (carrier_type),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='承运商表';

-- 8.2 运单表
CREATE TABLE waybill (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    waybill_no      VARCHAR(50)         NOT NULL COMMENT '运单号',
    carrier_id      BIGINT UNSIGNED     NOT NULL COMMENT '承运商ID',
    business_type   TINYINT UNSIGNED    NOT NULL COMMENT '业务类型: 1销售 2采购退货 3调拨',
    business_id     BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    sender_name     VARCHAR(50)         NOT NULL COMMENT '寄件人',
    sender_phone    VARCHAR(20)         NOT NULL COMMENT '寄件人电话',
    sender_address  VARCHAR(255)        NOT NULL COMMENT '寄件地址',
    receiver_name   VARCHAR(50)         NOT NULL COMMENT '收件人',
    receiver_phone  VARCHAR(20)         NOT NULL COMMENT '收件人电话',
    receiver_address VARCHAR(255)       NOT NULL COMMENT '收件地址',
    weight          DECIMAL(10,3)       DEFAULT NULL COMMENT '重量(kg)',
    volume          DECIMAL(10,4)       DEFAULT NULL COMMENT '体积(m³)',
    package_count   INT UNSIGNED        NOT NULL DEFAULT 1 COMMENT '包裹数',
    freight_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '运费',
    insured_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '保价金额',
    delivery_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '配送类型: 1标准 2次日达 3当日达 4定时达',
    ship_time       DATETIME            DEFAULT NULL COMMENT '发货时间',
    receive_time    DATETIME            DEFAULT NULL COMMENT '签收时间',
    logistics_status TINYINT UNSIGNED   NOT NULL DEFAULT 0 COMMENT '物流状态: 0待揽收 1已揽收 2运输中 3已到达 4派送中 5已签收 6拒收 7异常',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_waybill_no (waybill_no),
    KEY idx_carrier_id (carrier_id),
    KEY idx_business_no (business_no),
    KEY idx_logistics_status (logistics_status),
    KEY idx_ship_time (ship_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运单表';

-- 8.3 物流跟踪表
CREATE TABLE logistics_track (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    waybill_id      BIGINT UNSIGNED     NOT NULL COMMENT '运单ID',
    track_time      DATETIME            NOT NULL COMMENT '跟踪时间',
    track_content   VARCHAR(500)        NOT NULL COMMENT '跟踪内容',
    operator        VARCHAR(50)         DEFAULT NULL COMMENT '操作人',
    operator_phone  VARCHAR(20)         DEFAULT NULL COMMENT '操作人电话',
    location        VARCHAR(100)        DEFAULT NULL COMMENT '当前位置',
    action_code     VARCHAR(20)         DEFAULT NULL COMMENT '动作编码',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_waybill_id (waybill_id),
    KEY idx_track_time (track_time),
    KEY idx_action_code (action_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='物流跟踪表';

-- 8.4 运费模板表
CREATE TABLE freight_template (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    template_name   VARCHAR(100)        NOT NULL COMMENT '模板名称',
    carrier_id      BIGINT UNSIGNED     NOT NULL COMMENT '承运商ID',
    pricing_type    TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '计价方式: 1按重量 2按体积 3按件数 4按距离',
    first_unit      DECIMAL(10,4)       NOT NULL DEFAULT 1.0000 COMMENT '首重/首件/首体积',
    first_price     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '首价',
    continue_unit   DECIMAL(10,4)       NOT NULL DEFAULT 1.0000 COMMENT '续重/续件/续体积',
    continue_price  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '续价',
    free_threshold  DECIMAL(18,4)       DEFAULT NULL COMMENT '包邮阈值',
    region_rules    JSON                DEFAULT NULL COMMENT '区域特殊规则',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_carrier_id (carrier_id),
    KEY idx_pricing_type (pricing_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='运费模板表';

-- ============================================================
-- 9. 财务管理 (Finance)
-- ============================================================

-- 9.1 应付单表
CREATE TABLE account_payable (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    payable_no      VARCHAR(32)         NOT NULL COMMENT '应付单号',
    business_type   TINYINT UNSIGNED    NOT NULL COMMENT '业务类型: 1采购货款 2运费 3服务费 4其他',
    business_id     BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    supplier_id     BIGINT UNSIGNED     NOT NULL COMMENT '供应商ID',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应付金额',
    paid_amount     DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已付金额',
    unpaid_amount   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '未付金额',
    invoice_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已开票金额',
    uninvoice_amount DECIMAL(18,4)      NOT NULL DEFAULT 0.0000 COMMENT '未开票金额',
    due_date        DATE                NOT NULL COMMENT '到期日',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    pay_status      TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '付款状态: 0未付款 1部分付款 2全部付款',
    invoice_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '开票状态: 0未开票 1部分开票 2全部开票',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已冲销 1待付款 2已付款',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_payable_no (payable_no),
    KEY idx_business_no (business_no),
    KEY idx_supplier_id (supplier_id),
    KEY idx_due_date (due_date),
    KEY idx_pay_status (pay_status),
    KEY idx_invoice_status (invoice_status),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='应付单表';

-- 9.2 应收单表
CREATE TABLE account_receivable (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    receivable_no   VARCHAR(32)         NOT NULL COMMENT '应收单号',
    business_type   TINYINT UNSIGNED    NOT NULL COMMENT '业务类型: 1销售货款 2服务费 3其他',
    business_id     BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    customer_id     BIGINT UNSIGNED     NOT NULL COMMENT '客户ID',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '应收金额',
    received_amount DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已收金额',
    unreceived_amount DECIMAL(18,4)     NOT NULL DEFAULT 0.0000 COMMENT '未收金额',
    invoice_amount  DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '已开票金额',
    uninvoice_amount DECIMAL(18,4)      NOT NULL DEFAULT 0.0000 COMMENT '未开票金额',
    due_date        DATE                NOT NULL COMMENT '到期日',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    receive_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '收款状态: 0未收款 1部分收款 2全部收款',
    invoice_status  TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '开票状态: 0未开票 1部分开票 2全部开票',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已冲销 1待收款 2已收款',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_receivable_no (receivable_no),
    KEY idx_business_no (business_no),
    KEY idx_customer_id (customer_id),
    KEY idx_due_date (due_date),
    KEY idx_receive_status (receive_status),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='应收单表';

-- 9.3 发票表
CREATE TABLE invoice (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    invoice_no      VARCHAR(50)         NOT NULL COMMENT '发票号码',
    invoice_code    VARCHAR(20)         DEFAULT NULL COMMENT '发票代码',
    invoice_type    TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '发票类型: 1增值税专用发票 2增值税普通发票 3电子发票 4机动车发票',
    direction       TINYINT UNSIGNED    NOT NULL COMMENT '方向: 1进项 2销项',
    business_type   TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '业务类型: 1采购 2销售 3其他',
    business_id     BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    party_id        BIGINT UNSIGNED     NOT NULL COMMENT '对方ID(供应商或客户)',
    party_name      VARCHAR(100)        NOT NULL COMMENT '对方名称',
    party_tax_no    VARCHAR(50)         DEFAULT NULL COMMENT '对方税号',
    amount_without_tax DECIMAL(18,4)    NOT NULL DEFAULT 0.0000 COMMENT '不含税金额',
    tax_amount      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '税额',
    amount_with_tax DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '含税金额',
    tax_rate        DECIMAL(5,2)        NOT NULL DEFAULT 13.00 COMMENT '税率(%)',
    invoice_date    DATE                NOT NULL COMMENT '开票日期',
    verify_status   TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '认证状态: 0未认证 1已认证 2认证失败',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0作废 1正常',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_invoice_no (invoice_no, invoice_code),
    KEY idx_business_no (business_no),
    KEY idx_party_id (party_id),
    KEY idx_invoice_date (invoice_date),
    KEY idx_direction (direction)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='发票表';

-- 9.4 结算单表
CREATE TABLE settlement (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    settlement_no   VARCHAR(32)         NOT NULL COMMENT '结算单号',
    settlement_type TINYINT UNSIGNED    NOT NULL COMMENT '结算类型: 1采购结算 2销售结算 3物流结算',
    party_id        BIGINT UNSIGNED     NOT NULL COMMENT '结算方ID',
    party_type      TINYINT UNSIGNED    NOT NULL COMMENT '结算方类型: 1供应商 2客户 3承运商',
    start_date      DATE                NOT NULL COMMENT '结算开始日期',
    end_date        DATE                NOT NULL COMMENT '结算结束日期',
    total_amount    DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '结算总金额',
    discount_amount DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '折扣金额',
    actual_amount   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '实际结算金额',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    settle_status   TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '结算状态: 0待确认 1已确认 2已付款/已收款 3已关闭',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_settlement_no (settlement_no),
    KEY idx_party_id (party_id),
    KEY idx_settlement_type (settlement_type),
    KEY idx_start_date (start_date),
    KEY idx_end_date (end_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='结算单表';

-- 9.4.1 结算明细表
CREATE TABLE settlement_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    settlement_id   BIGINT UNSIGNED     NOT NULL COMMENT '结算单ID',
    source_type     TINYINT UNSIGNED    NOT NULL COMMENT '来源类型: 1应付单 2应收单 3付款记录',
    source_id       BIGINT UNSIGNED     NOT NULL COMMENT '来源单据ID',
    source_no       VARCHAR(32)         NOT NULL COMMENT '来源单号',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '原始金额',
    settle_amount   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '本次结算金额',
    discount_amount DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '折扣金额',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0取消 1待结算 2已结算',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_settlement_id (settlement_id),
    KEY idx_source_type_id (source_type, source_id),
    KEY idx_source_no (source_no),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='结算明细表';

-- 9.5 付款记录表
CREATE TABLE payment_record (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    payment_no      VARCHAR(32)         NOT NULL COMMENT '付款单号',
    payment_type    TINYINT UNSIGNED    NOT NULL COMMENT '付款类型: 1采购付款 2物流付款 3其他付款 4销售收款',
    business_id     BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    business_no     VARCHAR(32)         NOT NULL COMMENT '业务单号',
    party_id        BIGINT UNSIGNED     NOT NULL COMMENT '收付款方ID',
    party_type      TINYINT UNSIGNED    NOT NULL COMMENT '收付款方类型: 1供应商 2客户 3承运商',
    amount          DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '金额',
    currency        VARCHAR(10)         NOT NULL DEFAULT 'CNY',
    payment_method  TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '支付方式: 1银行转账 2现金 3支票 4电汇 5承兑汇票 6在线支付',
    bank_account    VARCHAR(50)         DEFAULT NULL COMMENT '银行账号',
    bank_name       VARCHAR(100)        DEFAULT NULL COMMENT '银行名称',
    payment_date    DATE                NOT NULL COMMENT '付款日期',
    voucher_no      VARCHAR(50)         DEFAULT NULL COMMENT '凭证号',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已作废 1已提交 2已审批 3已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_payment_no (payment_no),
    KEY idx_business_no (business_no),
    KEY idx_party_id (party_id),
    KEY idx_payment_date (payment_date),
    KEY idx_payment_type (payment_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='付款记录表';

) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='付款记录表';

-- ============================================================
-- 10. 审批流水 (Approval)
-- ============================================================

-- 10.1 审批流水表
CREATE TABLE approval_record (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    biz_type        VARCHAR(50)         NOT NULL COMMENT '业务类型: purchase_request/supplier_contract/purchase_return/sales_return等',
    biz_id          BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    biz_no          VARCHAR(32)         NOT NULL COMMENT '业务单号',
    step_no         TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '审批步骤序号',
    step_name       VARCHAR(50)         NOT NULL COMMENT '审批步骤名称',
    approver_id     BIGINT UNSIGNED     NOT NULL COMMENT '审批人ID',
    approver_name   VARCHAR(50)         NOT NULL COMMENT '审批人姓名',
    action          TINYINT UNSIGNED    NOT NULL COMMENT '审批动作: 1通过 2拒绝 3转交 4撤回',
    comment         VARCHAR(500)        DEFAULT NULL COMMENT '审批意见',
    approve_time    DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '审批时间',
    next_approver_id BIGINT UNSIGNED    DEFAULT NULL COMMENT '下一审批人ID(转交时)',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY idx_biz_type_id (biz_type, biz_id),
    KEY idx_biz_no (biz_no),
    KEY idx_approver_id (approver_id),
    KEY idx_approve_time (approve_time),
    KEY idx_action (action)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='审批流水表';

-- ============================================================
-- 11. 质检管理 (Quality Control)
-- ============================================================

-- 11.1 质检单表
CREATE TABLE quality_check (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    check_no        VARCHAR(32)         NOT NULL COMMENT '质检单号',
    check_type      TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '质检类型: 1采购入库质检 2退货质检 3库存抽检',
    source_type     TINYINT UNSIGNED    NOT NULL COMMENT '来源类型: 1采购入库单 2销售退货单 3库存盘点',
    source_id       BIGINT UNSIGNED     NOT NULL COMMENT '来源单据ID',
    source_no       VARCHAR(32)         NOT NULL COMMENT '来源单号',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    supplier_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '供应商ID',
    checker_id      BIGINT UNSIGNED     NOT NULL COMMENT '质检员ID',
    check_date      DATE                NOT NULL COMMENT '质检日期',
    total_sku_count INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT 'SKU种类数',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '送检总数量',
    qualified_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '合格数量',
    unqualified_qty DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '不合格数量',
    check_result    TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '质检结论: 0待质检 1全部合格 2部分合格 3全部不合格',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已取消 1待质检 2质检中 3已完成',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_check_no (check_no),
    KEY idx_source_type_id (source_type, source_id),
    KEY idx_source_no (source_no),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_supplier_id (supplier_id),
    KEY idx_checker_id (checker_id),
    KEY idx_check_date (check_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质检单表';

-- 11.2 质检明细表
CREATE TABLE quality_check_item (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    check_id        BIGINT UNSIGNED     NOT NULL COMMENT '质检单ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    sku_name        VARCHAR(200)        NOT NULL COMMENT 'SKU名称快照',
    batch_no        VARCHAR(32)         DEFAULT NULL COMMENT '批次号',
    check_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '送检数量',
    qualified_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '合格数量',
    unqualified_qty DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '不合格数量',
    defect_type     VARCHAR(100)        DEFAULT NULL COMMENT '缺陷类型',
    defect_desc     VARCHAR(500)        DEFAULT NULL COMMENT '缺陷描述',
    disposal_type   TINYINT UNSIGNED    DEFAULT NULL COMMENT '不合格处理方式: 1退货 2报废 3让步接收 4返工',
    check_result    TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '质检结论: 0待质检 1合格 2不合格 3让步接收',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    KEY idx_check_id (check_id),
    KEY idx_sku_id (sku_id),
    KEY idx_batch_no (batch_no),
    KEY idx_check_result (check_result),
    KEY idx_disposal_type (disposal_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='质检明细表';

-- ============================================================
-- 12. 系统日志 (System Log)
-- ============================================================

-- 12.1 操作日志表
CREATE TABLE operation_log (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    user_id         BIGINT UNSIGNED     NOT NULL COMMENT '操作人ID',
    user_name       VARCHAR(50)         NOT NULL COMMENT '操作人姓名(快照)',
    biz_type        VARCHAR(50)         NOT NULL COMMENT '业务类型',
    biz_id          BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    biz_no          VARCHAR(32)         NOT NULL COMMENT '业务单号',
    action          VARCHAR(50)         NOT NULL COMMENT '操作动作: create/update/delete/approve/cancel等',
    action_desc     VARCHAR(200)        NOT NULL COMMENT '操作描述',
    before_data     JSON                DEFAULT NULL COMMENT '变更前数据快照',
    after_data      JSON                DEFAULT NULL COMMENT '变更后数据快照',
    diff_fields     JSON                DEFAULT NULL COMMENT '变更字段列表',
    ip_address      VARCHAR(40)         DEFAULT NULL COMMENT '操作IP',
    user_agent      VARCHAR(255)        DEFAULT NULL COMMENT '客户端信息',
    operation_time  DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1,
    PRIMARY KEY (id),
    KEY idx_user_id (user_id),
    KEY idx_biz_type_id (biz_type, biz_id),
    KEY idx_biz_no (biz_no),
    KEY idx_action (action),
    KEY idx_operation_time (operation_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='操作日志表';

-- 12.2 客户统计表 (从 customer 主表拆分出的统计数据)
CREATE TABLE customer_stat (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    customer_id     BIGINT UNSIGNED     NOT NULL COMMENT '客户ID',
    stat_date       DATE                NOT NULL COMMENT '统计日期',
    total_deal_amount DECIMAL(18,2)     NOT NULL DEFAULT 0.00 COMMENT '累计交易金额',
    total_deal_count INT UNSIGNED       NOT NULL DEFAULT 0 COMMENT '累计交易次数',
    month_amount    DECIMAL(18,2)       NOT NULL DEFAULT 0.00 COMMENT '当月交易金额',
    month_count     INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '当月交易次数',
    last_deal_date  DATE                DEFAULT NULL COMMENT '最后交易日期',
    credit_used     DECIMAL(18,2)       NOT NULL DEFAULT 0.00 COMMENT '已用信用额度',
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_customer_stat_date (customer_id, stat_date),
    KEY idx_customer_id (customer_id),
    KEY idx_stat_date (stat_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='客户统计表';

-- 12.3 库存批次明细表 (从 inventory 拆分批次职责)
CREATE TABLE inventory_batch (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    inventory_id    BIGINT UNSIGNED     NOT NULL COMMENT '库存台账ID',
    sku_id          BIGINT UNSIGNED     NOT NULL COMMENT 'SKU_ID',
    warehouse_id    BIGINT UNSIGNED     NOT NULL COMMENT '仓库ID',
    location_id     BIGINT UNSIGNED     DEFAULT NULL COMMENT '库位ID',
    batch_no        VARCHAR(32)         NOT NULL COMMENT '批次号',
    production_date DATE                DEFAULT NULL COMMENT '生产日期',
    expiry_date     DATE                DEFAULT NULL COMMENT '有效期至',
    available_qty   DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '可用数量',
    frozen_qty      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '冻结数量',
    total_qty       DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '批次总数量',
    cost_price      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '批次成本价',
    total_cost      DECIMAL(18,4)       NOT NULL DEFAULT 0.0000 COMMENT '批次总成本',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0已清零 1正常',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_sku_wh_loc_batch (sku_id, warehouse_id, location_id, batch_no),
    KEY idx_inventory_id (inventory_id),
    KEY idx_sku_id (sku_id),
    KEY idx_warehouse_id (warehouse_id),
    KEY idx_location_id (location_id),
    KEY idx_batch_no (batch_no),
    KEY idx_expiry_date (expiry_date),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='库存批次明细表';

-- 12.4 预警通知规则表
CREATE TABLE alert_rule (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    rule_code       VARCHAR(50)         NOT NULL COMMENT '规则编码',
    rule_name       VARCHAR(100)        NOT NULL COMMENT '规则名称',
    rule_type       TINYINT UNSIGNED    NOT NULL COMMENT '规则类型: 1库存预警 2合同到期 3订单超期 4付款到期 5质检异常',
    biz_type        VARCHAR(50)         DEFAULT NULL COMMENT '关联业务类型',
    condition_expr  VARCHAR(500)        NOT NULL COMMENT '触发条件表达式(JSON格式)',
    notify_channels JSON                NOT NULL COMMENT '通知渠道: ["email","sms","system"]',
    notify_users    JSON                DEFAULT NULL COMMENT '通知用户ID列表',
    notify_roles    JSON                DEFAULT NULL COMMENT '通知角色ID列表',
    advance_days    INT UNSIGNED        NOT NULL DEFAULT 0 COMMENT '提前预警天数',
    is_repeat       TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否重复通知: 0否 1是',
    repeat_interval INT UNSIGNED        DEFAULT NULL COMMENT '重复间隔(分钟)',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0禁用 1启用',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    updated_by      BIGINT UNSIGNED     NOT NULL DEFAULT 0,
    deleted_at      DATETIME            DEFAULT NULL,
    version         INT UNSIGNED        NOT NULL DEFAULT 1,
    remark          VARCHAR(500)        DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uk_rule_code (rule_code),
    KEY idx_rule_type (rule_type),
    KEY idx_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='预警通知规则表';

-- 12.5 通知消息表
CREATE TABLE notification (
    id              BIGINT UNSIGNED     NOT NULL AUTO_INCREMENT,
    rule_id         BIGINT UNSIGNED     DEFAULT NULL COMMENT '触发规则ID',
    biz_type        VARCHAR(50)         NOT NULL COMMENT '业务类型',
    biz_id          BIGINT UNSIGNED     NOT NULL COMMENT '业务单据ID',
    biz_no          VARCHAR(32)         NOT NULL COMMENT '业务单号',
    title           VARCHAR(200)        NOT NULL COMMENT '通知标题',
    content         TEXT                NOT NULL COMMENT '通知内容',
    notify_type     TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '通知类型: 1系统消息 2邮件 3短信',
    receiver_id     BIGINT UNSIGNED     NOT NULL COMMENT '接收人ID',
    receiver_name   VARCHAR(50)         NOT NULL COMMENT '接收人姓名',
    is_read         TINYINT UNSIGNED    NOT NULL DEFAULT 0 COMMENT '是否已读: 0未读 1已读',
    read_time       DATETIME            DEFAULT NULL COMMENT '阅读时间',
    send_time       DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '发送时间',
    status          TINYINT UNSIGNED    NOT NULL DEFAULT 1 COMMENT '状态: 0发送失败 1已发送',
    created_at      DATETIME            NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    KEY idx_rule_id (rule_id),
    KEY idx_biz_type_id (biz_type, biz_id),
    KEY idx_receiver_id (receiver_id),
    KEY idx_is_read (is_read),
    KEY idx_send_time (send_time)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='通知消息表';

-- ============================================================
-- 13. 外键约束 (可选, 生产环境建议应用层控制)
-- ============================================================

-- 注意: 为了性能考虑, 生产环境外键通常在应用层控制。
-- 以下外键仅用于开发/学习环境的完整性约束:

-- ALTER TABLE product_spu ADD CONSTRAINT fk_spu_category FOREIGN KEY (category_id) REFERENCES category(id);
-- ALTER TABLE product_spu ADD CONSTRAINT fk_spu_brand FOREIGN KEY (brand_id) REFERENCES brand(id);
-- ALTER TABLE product_sku ADD CONSTRAINT fk_sku_spu FOREIGN KEY (spu_id) REFERENCES product_spu(id);
-- ALTER TABLE product_price ADD CONSTRAINT fk_price_sku FOREIGN KEY (sku_id) REFERENCES product_sku(id);
-- ALTER TABLE product_barcode ADD CONSTRAINT fk_barcode_sku FOREIGN KEY (sku_id) REFERENCES product_sku(id);
-- ALTER TABLE supplier_contact ADD CONSTRAINT fk_contact_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id);
-- ALTER TABLE supplier_rating ADD CONSTRAINT fk_rating_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id);
-- ALTER TABLE supplier_contract ADD CONSTRAINT fk_contract_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id);
-- ALTER TABLE purchase_request_item ADD CONSTRAINT fk_pri_request FOREIGN KEY (request_id) REFERENCES purchase_request(id);
-- ALTER TABLE purchase_order ADD CONSTRAINT fk_po_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id);
-- ALTER TABLE purchase_order_item ADD CONSTRAINT fk_poi_order FOREIGN KEY (order_id) REFERENCES purchase_order(id);
-- ALTER TABLE warehouse_location ADD CONSTRAINT fk_loc_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse(id);
-- ALTER TABLE inventory ADD CONSTRAINT fk_inv_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse(id);
-- ALTER TABLE customer ADD CONSTRAINT fk_cust_level FOREIGN KEY (level_id) REFERENCES customer_level(id);
-- ALTER TABLE sales_order ADD CONSTRAINT fk_so_customer FOREIGN KEY (customer_id) REFERENCES customer(id);
-- ALTER TABLE sales_order_item ADD CONSTRAINT fk_soi_order FOREIGN KEY (order_id) REFERENCES sales_order(id);
-- ALTER TABLE wms_inbound ADD CONSTRAINT fk_wi_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse(id);
-- ALTER TABLE wms_outbound ADD CONSTRAINT fk_wo_warehouse FOREIGN KEY (warehouse_id) REFERENCES warehouse(id);
-- ALTER TABLE waybill ADD CONSTRAINT fk_wb_carrier FOREIGN KEY (carrier_id) REFERENCES carrier(id);
-- ALTER TABLE logistics_track ADD CONSTRAINT fk_lt_waybill FOREIGN KEY (waybill_id) REFERENCES waybill(id);
-- ALTER TABLE account_payable ADD CONSTRAINT fk_ap_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id);
-- ALTER TABLE account_receivable ADD CONSTRAINT fk_ar_customer FOREIGN KEY (customer_id) REFERENCES customer(id);

-- ============================================================
-- 脚本结束
-- ============================================================
