SET NAMES utf8mb4;
USE `supply_chain_center`;

START TRANSACTION;

INSERT INTO `sys_tenant` (`id`,`tenant_code`,`tenant_name`,`status`,`contact_name`,`contact_mobile`,`expire_at`,`created_by`,`updated_by`,`remark`) VALUES
(1,'demo-scm','星云供应链集团','ENABLED','李总','13800000001','2035-12-31 23:59:59.000',1,1,'演示租户');

INSERT INTO `sys_org` (`id`,`tenant_id`,`parent_id`,`org_code`,`org_name`,`org_type`,`org_level`,`path`,`leader_id`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(1001,1,0,'ORG-HQ','星云供应链总部','COMPANY',1,'/1001/',2001,'ENABLED',1,1,'总部'),
(1002,1,1001,'ORG-EAST','华东事业部','DIVISION',2,'/1001/1002/',2002,'ENABLED',1,1,'华东区域'),
(1003,1,1001,'ORG-SOUTH','华南事业部','DIVISION',2,'/1001/1003/',2003,'ENABLED',1,1,'华南区域');

INSERT INTO `sys_dept` (`id`,`tenant_id`,`org_id`,`parent_id`,`dept_code`,`dept_name`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(1101,1,1001,0,'DEP-PUR','采购中心','ENABLED',1,1,''),
(1102,1,1001,0,'DEP-WMS','仓储中心','ENABLED',1,1,''),
(1103,1,1001,0,'DEP-SALES','销售中心','ENABLED',1,1,''),
(1104,1,1001,0,'DEP-FIN','财务中心','ENABLED',1,1,'');

INSERT INTO `sys_user` (`id`,`tenant_id`,`org_id`,`dept_id`,`username`,`real_name`,`mobile`,`email`,`password_hash`,`status`,`last_login_at`,`created_by`,`updated_by`,`remark`) VALUES
(2001,1,1001,1104,'admin','超级管理员','13800000011','admin@demo.com','$2a$10$demo.hash.admin','ENABLED','2026-04-24 09:00:00.000',1,1,''),
(2002,1,1002,1101,'buyer.east','华东采购经理','13800000012','buyer.east@demo.com','$2a$10$demo.hash.buyer','ENABLED','2026-04-24 09:10:00.000',1,1,''),
(2003,1,1003,1102,'wms.south','华南仓储主管','13800000013','wms.south@demo.com','$2a$10$demo.hash.wms','ENABLED','2026-04-24 09:20:00.000',1,1,''),
(2004,1,1002,1103,'sales.east','华东销售经理','13800000014','sales.east@demo.com','$2a$10$demo.hash.sales','ENABLED','2026-04-24 09:30:00.000',1,1,'');

INSERT INTO `sys_role` (`id`,`tenant_id`,`role_code`,`role_name`,`role_type`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(3001,1,'ROLE_ADMIN','系统管理员','PLATFORM','ENABLED',1,1,''),
(3002,1,'ROLE_BUYER','采购经理','BUSINESS','ENABLED',1,1,''),
(3003,1,'ROLE_WMS','仓储主管','BUSINESS','ENABLED',1,1,''),
(3004,1,'ROLE_SALES','销售经理','BUSINESS','ENABLED',1,1,'');

INSERT INTO `sys_user_role` (`id`,`tenant_id`,`user_id`,`role_id`,`created_by`,`updated_by`,`remark`) VALUES
(3101,1,2001,3001,1,1,''),
(3102,1,2002,3002,1,1,''),
(3103,1,2003,3003,1,1,''),
(3104,1,2004,3004,1,1,'');

INSERT INTO `sys_menu` (`id`,`tenant_id`,`parent_id`,`menu_code`,`menu_name`,`menu_type`,`path`,`component`,`permission_code`,`sort_no`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(3201,1,0,'MENU-SCM','供应链中台','MENU','/scm','Layout','',1,'ENABLED',1,1,''),
(3202,1,3201,'MENU-PUR','采购中心','MENU','/scm/purchase','purchase/index','purchase:view',10,'ENABLED',1,1,''),
(3203,1,3201,'MENU-INV','库存中心','MENU','/scm/inventory','inventory/index','inventory:view',20,'ENABLED',1,1,''),
(3204,1,3201,'MENU-WMS','仓储中心','MENU','/scm/wms','wms/index','wms:view',30,'ENABLED',1,1,''),
(3205,1,3201,'MENU-SALES','销售中心','MENU','/scm/sales','sales/index','sales:view',40,'ENABLED',1,1,'');

INSERT INTO `sys_role_menu` (`id`,`tenant_id`,`role_id`,`menu_id`,`created_by`,`updated_by`,`remark`) VALUES
(3301,1,3001,3201,1,1,''),(3302,1,3001,3202,1,1,''),(3303,1,3001,3203,1,1,''),(3304,1,3001,3204,1,1,''),(3305,1,3001,3205,1,1,''),
(3306,1,3002,3202,1,1,''),(3307,1,3002,3203,1,1,''),
(3308,1,3003,3203,1,1,''),(3309,1,3003,3204,1,1,''),
(3310,1,3004,3203,1,1,''),(3311,1,3004,3205,1,1,'');

INSERT INTO `sys_data_permission` (`id`,`tenant_id`,`role_id`,`data_scope`,`org_id`,`warehouse_id`,`ext_json`,`created_by`,`updated_by`,`remark`) VALUES
(3401,1,3001,'ALL',0,0,JSON_OBJECT('level','platform'),1,1,''),
(3402,1,3002,'ORG',1002,0,JSON_OBJECT('orgCode','ORG-EAST'),1,1,''),
(3403,1,3003,'WAREHOUSE',0,5002,JSON_OBJECT('warehouseCode','WH-SZ-FIN'),1,1,''),
(3404,1,3004,'ORG',1002,0,JSON_OBJECT('orgCode','ORG-EAST'),1,1,'');

INSERT INTO `mdm_supplier` (`id`,`tenant_id`,`supplier_code`,`supplier_name`,`supplier_type`,`supplier_level`,`contact_name`,`contact_mobile`,`contact_email`,`province`,`city`,`district`,`address`,`tax_no`,`bank_name`,`bank_account`,`settlement_type`,`payment_term`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4001,1,'SUP-APPLE','华北果蔬供应有限公司','MANUFACTURER','A','王建国','13900000001','wang@apple-sup.com','山东省','烟台市','福山区','烟台福山食品工业园1号','91370000APPLE001','中国银行烟台分行','6222000000000001','MONTHLY','30D','ENABLED',1,1,'水果核心供应商'),
(4002,1,'SUP-DAIRY','优鲜乳业股份有限公司','MANUFACTURER','A','周海峰','13900000002','zhou@dairy.com','河北省','石家庄市','长安区','石家庄高新区8号','91130000DAIRY002','建设银行石家庄分行','6222000000000002','MONTHLY','45D','ENABLED',1,1,'冷链商品供应商');

INSERT INTO `mdm_supplier_contact` (`id`,`tenant_id`,`supplier_id`,`contact_name`,`mobile`,`email`,`position`,`is_default`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4101,1,4001,'王建国','13900000001','wang@apple-sup.com','销售总监',1,'ENABLED',1,1,''),
(4102,1,4002,'周海峰','13900000002','zhou@dairy.com','KA经理',1,'ENABLED',1,1,'');

INSERT INTO `mdm_customer` (`id`,`tenant_id`,`customer_code`,`customer_name`,`customer_type`,`customer_level`,`contact_name`,`contact_mobile`,`contact_email`,`province`,`city`,`district`,`address`,`tax_no`,`settlement_type`,`payment_term`,`credit_limit`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4201,1,'CUS-HMART','华美连锁超市','RETAIL','A','陈晓','13700000001','chen@hmart.com','上海市','上海市','浦东新区','浦东新区张江路88号','91310000HMART001','MONTHLY','30D',500000.000000,'ENABLED',1,1,'KA客户'),
(4202,1,'CUS-QSHOP','全渠道电商旗舰店','ECOM','A','刘婷','13700000002','liu@qshop.com','广东省','深圳市','南山区','南山区科技园9号','91440000QSHOP002','PREPAID','0D',200000.000000,'ENABLED',1,1,'线上渠道');

INSERT INTO `mdm_customer_contact` (`id`,`tenant_id`,`customer_id`,`contact_name`,`mobile`,`email`,`position`,`is_default`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4301,1,4201,'陈晓','13700000001','chen@hmart.com','采购总监',1,'ENABLED',1,1,''),
(4302,1,4202,'刘婷','13700000002','liu@qshop.com','运营经理',1,'ENABLED',1,1,'');

INSERT INTO `mdm_brand` (`id`,`tenant_id`,`brand_code`,`brand_name`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4401,1,'BR-ORCHARD','果源优品','ENABLED',1,1,''),
(4402,1,'BR-MILKY','牧鲜','ENABLED',1,1,'');

INSERT INTO `mdm_category` (`id`,`tenant_id`,`parent_id`,`category_code`,`category_name`,`category_level`,`path`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4501,1,0,'CAT-FOOD','食品',1,'/4501/','ENABLED',1,1,''),
(4502,1,4501,'CAT-FRUIT','水果',2,'/4501/4502/','ENABLED',1,1,''),
(4503,1,4501,'CAT-DAIRY','乳品',2,'/4501/4503/','ENABLED',1,1,'');

INSERT INTO `mdm_unit` (`id`,`tenant_id`,`unit_code`,`unit_name`,`unit_type`,`precision_digits`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4601,1,'PCS','件','QTY',0,'ENABLED',1,1,''),
(4602,1,'BOX','箱','QTY',0,'ENABLED',1,1,''),
(4603,1,'KG','千克','WEIGHT',3,'ENABLED',1,1,'');

INSERT INTO `mdm_tax_rate` (`id`,`tenant_id`,`tax_code`,`tax_name`,`tax_rate`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4701,1,'TAX9','农产品9%税率',0.0900,'ENABLED',1,1,''),
(4702,1,'TAX13','食品13%税率',0.1300,'ENABLED',1,1,'');

INSERT INTO `mdm_warehouse` (`id`,`tenant_id`,`org_id`,`warehouse_code`,`warehouse_name`,`warehouse_type`,`warehouse_level`,`province`,`city`,`district`,`address`,`manager_id`,`phone`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5001,1,1002,'WH-SH-CDC','上海中央仓','CDC','L1','上海市','上海市','浦东新区','浦东机场物流园A1',2003,'021-88880001','ENABLED',1,1,'华东主仓'),
(5002,1,1003,'WH-SZ-FIN','深圳成品仓','RDC','L2','广东省','深圳市','宝安区','深圳宝安机场物流园B3',2003,'0755-88880002','ENABLED',1,1,'华南成品仓');

INSERT INTO `mdm_warehouse_area` (`id`,`tenant_id`,`warehouse_id`,`area_code`,`area_name`,`area_type`,`temperature_type`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5101,1,5001,'A-REC','收货区','RECEIVING','NORMAL','ENABLED',1,1,''),
(5102,1,5001,'A-STO','常温存储区','STORAGE','NORMAL','ENABLED',1,1,''),
(5103,1,5002,'A-COLD','冷链库区','STORAGE','COLD','ENABLED',1,1,'');

INSERT INTO `mdm_location` (`id`,`tenant_id`,`warehouse_id`,`area_id`,`location_code`,`location_name`,`location_type`,`length`,`width`,`height`,`capacity_qty`,`is_pickable`,`is_locked`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5201,1,5001,5101,'SH-REC-01','上海收货位01','DOCK',2.000000,2.000000,2.500000,1000.000000,0,0,'ENABLED',1,1,''),
(5202,1,5001,5102,'SH-A01-01','上海货架A01-01','SHELF',1.200000,0.800000,2.000000,500.000000,1,0,'ENABLED',1,1,''),
(5203,1,5001,5102,'SH-A01-02','上海货架A01-02','SHELF',1.200000,0.800000,2.000000,500.000000,1,0,'ENABLED',1,1,''),
(5204,1,5002,5103,'SZ-C01-01','深圳冷库C01-01','COLD_SHELF',1.200000,1.000000,2.000000,300.000000,1,0,'ENABLED',1,1,'');

INSERT INTO `product_spu` (`id`,`tenant_id`,`spu_code`,`spu_name`,`category_id`,`brand_id`,`product_type`,`status`,`attr_json`,`created_by`,`updated_by`,`remark`) VALUES
(6001,1,'SPU-APPLE','山东红富士苹果',4502,4401,'NORMAL','ENABLED',JSON_OBJECT('origin','山东','grade','A'),1,1,''),
(6002,1,'SPU-MILK','高钙纯牛奶',4503,4402,'NORMAL','ENABLED',JSON_OBJECT('origin','河北','fat','3.6%'),1,1,'');

INSERT INTO `product_sku` (`id`,`tenant_id`,`spu_id`,`sku_code`,`sku_name`,`barcode`,`spec_json`,`base_unit_id`,`assist_unit_id`,`unit_convert_rate`,`weight`,`volume`,`length`,`width`,`height`,`cost_price`,`sale_price`,`tax_rate_id`,`batch_required`,`serial_required`,`shelf_life_days`,`enable_negative_stock`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6101,1,6001,'SKU-APPLE-5KG','山东红富士苹果 5KG/箱','690100000001',JSON_OBJECT('package','5KG/箱','grade','A'),4602,4603,5.000000,5.000000,0.018000,0.400000,0.300000,0.150000,28.000000,45.000000,4701,1,0,30,0,'ENABLED',1,1,''),
(6102,1,6002,'SKU-MILK-250ML-24','高钙纯牛奶 250ML*24','690100000002',JSON_OBJECT('package','250ML*24','temperature','冷藏'),4602,4601,24.000000,6.500000,0.020000,0.380000,0.260000,0.160000,52.000000,79.000000,4702,1,0,180,0,'ENABLED',1,1,'');

INSERT INTO `product_sku_barcode` (`id`,`tenant_id`,`sku_id`,`barcode`,`barcode_type`,`is_primary`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6201,1,6101,'690100000001','EAN13',1,'ENABLED',1,1,''),
(6202,1,6102,'690100000002','EAN13',1,'ENABLED',1,1,'');

INSERT INTO `product_sku_attr` (`id`,`tenant_id`,`sku_id`,`attr_code`,`attr_name`,`attr_value`,`created_by`,`updated_by`,`remark`) VALUES
(6301,1,6101,'ORIGIN','产地','山东烟台',1,1,''),
(6302,1,6101,'GRADE','等级','A级',1,1,''),
(6303,1,6102,'TEMP','温层','2-6摄氏度',1,1,'');

INSERT INTO `product_price` (`id`,`tenant_id`,`sku_id`,`price_type`,`org_id`,`customer_id`,`currency`,`price`,`effective_from`,`effective_to`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6401,1,6101,'SALE',1002,0,'CNY',45.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6402,1,6101,'PURCHASE',1002,0,'CNY',28.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6403,1,6102,'SALE',1003,0,'CNY',79.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6404,1,6102,'PURCHASE',1003,0,'CNY',52.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,'');

INSERT INTO `purchase_requisition` (`id`,`tenant_id`,`req_no`,`org_id`,`req_type`,`req_status`,`approve_status`,`required_date`,`applicant_id`,`total_amount`,`created_by`,`updated_by`,`remark`) VALUES
(7001,1,'PR202604240001',1002,'NORMAL','APPROVED','APPROVED','2026-04-28',2002,5600.000000,2002,2002,'华东苹果补货');

INSERT INTO `purchase_requisition_line` (`id`,`tenant_id`,`req_id`,`line_no`,`sku_id`,`unit_id`,`req_qty`,`converted_qty`,`estimated_price`,`estimated_amount`,`required_date`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7101,1,7001,1,6101,4602,200.000000,1000.000000,28.000000,5600.000000,'2026-04-28','OPEN',2002,2002,'');

INSERT INTO `purchase_order` (`id`,`tenant_id`,`po_no`,`org_id`,`supplier_id`,`warehouse_id`,`source_type`,`source_no`,`currency`,`po_status`,`approve_status`,`delivery_status`,`expected_arrival_date`,`total_amount`,`discount_amount`,`tax_amount`,`payable_amount`,`created_by`,`updated_by`,`remark`) VALUES
(7201,1,'PO202604240001',1002,4001,5001,'REQUISITION','PR202604240001','CNY','APPROVED','APPROVED','PARTIAL','2026-04-27',5600.000000,0.000000,504.000000,6104.000000,2002,2002,'苹果采购单'),
(7202,1,'PO202604240002',1003,4002,5002,'MANUAL','','CNY','APPROVED','APPROVED','PENDING','2026-04-29',5200.000000,0.000000,676.000000,5876.000000,2002,2002,'牛奶采购单');

INSERT INTO `purchase_order_line` (`id`,`tenant_id`,`po_id`,`line_no`,`source_line_id`,`sku_id`,`unit_id`,`order_qty`,`received_qty`,`returned_qty`,`pending_qty`,`unit_price`,`discount_amount`,`tax_rate`,`tax_amount`,`line_amount`,`delivery_date`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7301,1,7201,1,7101,6101,4602,200.000000,120.000000,0.000000,80.000000,28.000000,0.000000,0.0900,504.000000,5600.000000,'2026-04-27','OPEN',2002,2002,''),
(7302,1,7202,1,0,6102,4602,100.000000,0.000000,0.000000,100.000000,52.000000,0.000000,0.1300,676.000000,5200.000000,'2026-04-29','OPEN',2002,2002,'');

INSERT INTO `purchase_receipt` (`id`,`tenant_id`,`receipt_no`,`po_id`,`supplier_id`,`warehouse_id`,`receipt_status`,`qc_status`,`received_at`,`created_by`,`updated_by`,`remark`) VALUES
(7401,1,'GR202604240001',7201,4001,5001,'COMPLETED','PASSED','2026-04-24 10:30:00.000',2003,2003,'苹果首批到货');

INSERT INTO `purchase_receipt_line` (`id`,`tenant_id`,`receipt_id`,`line_no`,`po_line_id`,`sku_id`,`batch_no`,`production_date`,`expire_date`,`received_qty`,`qualified_qty`,`rejected_qty`,`unit_cost`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7501,1,7401,1,7301,6101,'BATCH-APPLE-20260424','2026-04-23','2026-05-23',120.000000,118.000000,2.000000,28.000000,'COMPLETED',2003,2003,'');

INSERT INTO `purchase_return_order` (`id`,`tenant_id`,`return_no`,`supplier_id`,`warehouse_id`,`source_receipt_id`,`status`,`approve_status`,`total_amount`,`created_by`,`updated_by`,`remark`) VALUES
(7601,1,'PRTN202604240001',4001,5001,7401,'APPROVED','APPROVED',56.000000,2002,2002,'质检不合格退货');

INSERT INTO `purchase_return_order_line` (`id`,`tenant_id`,`return_id`,`line_no`,`source_receipt_line_id`,`sku_id`,`batch_no`,`return_qty`,`unit_price`,`line_amount`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7701,1,7601,1,7501,6101,'BATCH-APPLE-20260424',2.000000,28.000000,56.000000,'OPEN',2002,2002,'');

INSERT INTO `sales_order` (`id`,`tenant_id`,`so_no`,`org_id`,`customer_id`,`warehouse_id`,`channel_type`,`source_order_no`,`sales_type`,`order_status`,`approve_status`,`payment_status`,`delivery_status`,`currency`,`total_amount`,`discount_amount`,`tax_amount`,`payable_amount`,`order_time`,`created_by`,`updated_by`,`remark`) VALUES
(8001,1,'SO202604240001',1002,4201,5001,'B2B','EXT-HMART-0001','NORMAL','APPROVED','APPROVED','PARTIAL','PARTIAL','CNY',4500.000000,100.000000,396.000000,4796.000000,'2026-04-24 11:00:00.000',2004,2004,'华美超市苹果订单'),
(8002,1,'SO202604240002',1003,4202,5002,'ECOM','EXT-QSHOP-0001','NORMAL','APPROVED','APPROVED','PAID','PENDING','CNY',7900.000000,0.000000,1027.000000,8927.000000,'2026-04-24 11:10:00.000',2004,2004,'电商牛奶订单');

INSERT INTO `sales_order_line` (`id`,`tenant_id`,`so_id`,`line_no`,`sku_id`,`unit_id`,`order_qty`,`allocated_qty`,`shipped_qty`,`returned_qty`,`pending_qty`,`unit_price`,`discount_amount`,`tax_rate`,`tax_amount`,`line_amount`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(8101,1,8001,1,6101,4602,100.000000,80.000000,60.000000,0.000000,40.000000,45.000000,100.000000,0.0900,396.000000,4500.000000,'OPEN',2004,2004,''),
(8102,1,8002,1,6102,4602,100.000000,0.000000,0.000000,0.000000,100.000000,79.000000,0.000000,0.1300,1027.000000,7900.000000,'OPEN',2004,2004,'');

INSERT INTO `sales_delivery_order` (`id`,`tenant_id`,`delivery_no`,`so_id`,`customer_id`,`warehouse_id`,`delivery_status`,`shipped_at`,`carrier_id`,`tracking_no`,`created_by`,`updated_by`,`remark`) VALUES
(8201,1,'DO202604240001',8001,4201,5001,'PARTIAL_SHIPPED','2026-04-24 14:00:00.000',9001,'YT202604240001',2003,2003,'苹果首批发货');

INSERT INTO `sales_delivery_order_line` (`id`,`tenant_id`,`delivery_id`,`line_no`,`so_line_id`,`sku_id`,`batch_no`,`delivery_qty`,`signed_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(8301,1,8201,1,8101,6101,'BATCH-APPLE-20260424',60.000000,0.000000,'OPEN',2003,2003,'');

INSERT INTO `sales_return_order` (`id`,`tenant_id`,`return_no`,`customer_id`,`source_so_id`,`warehouse_id`,`status`,`approve_status`,`refund_status`,`refund_amount`,`created_by`,`updated_by`,`remark`) VALUES
(8401,1,'SRT202604240001',4201,8001,5001,'APPROVED','APPROVED','PENDING',90.000000,2004,2004,'客户破损退货');

INSERT INTO `sales_return_order_line` (`id`,`tenant_id`,`return_id`,`line_no`,`source_so_line_id`,`sku_id`,`batch_no`,`return_qty`,`unit_price`,`refund_amount`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(8501,1,8401,1,8101,6101,'BATCH-APPLE-20260424',2.000000,45.000000,90.000000,'OPEN',2004,2004,'');

INSERT INTO `inventory_stock` (`id`,`tenant_id`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`owner_type`,`owner_id`,`qty_on_hand`,`qty_available`,`qty_reserved`,`qty_locked`,`qty_in_transit`,`qty_damaged`,`last_txn_time`,`version`,`updated_at`) VALUES
(9001,1,1002,5001,5202,6101,'BATCH-APPLE-20260424','GOOD','SELF',0,116.000000,36.000000,80.000000,0.000000,0.000000,0.000000,'2026-04-24 14:00:00.000',3,'2026-04-24 14:00:00.000'),
(9002,1,1003,5002,5204,6102,'BATCH-MILK-PLAN-20260429','GOOD','SELF',0,0.000000,0.000000,0.000000,0.000000,100.000000,0.000000,'2026-04-24 11:10:00.000',1,'2026-04-24 11:10:00.000');

INSERT INTO `inventory_batch` (`id`,`tenant_id`,`warehouse_id`,`sku_id`,`batch_no`,`production_date`,`expire_date`,`supplier_id`,`receipt_no`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(9101,1,5001,6101,'BATCH-APPLE-20260424','2026-04-23','2026-05-23',4001,'GR202604240001','ENABLED',2003,2003,''),
(9102,1,5002,6102,'BATCH-MILK-PLAN-20260429','2026-04-29','2026-10-26',4002,'','ENABLED',2003,2003,'计划批次');

INSERT INTO `inventory_serial_no` (`id`,`tenant_id`,`sku_id`,`serial_no`,`warehouse_id`,`location_id`,`stock_status`,`biz_status`,`source_biz_no`,`created_by`,`updated_by`,`remark`) VALUES
(9201,1,6102,'SN-MILK-DEMO-0001',5002,5204,'GOOD','IN_TRANSIT','PO202604240002',2003,2003,'演示序列号');

INSERT INTO `inventory_txn` (`id`,`tenant_id`,`txn_no`,`biz_type`,`biz_no`,`biz_line_no`,`direction`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`before_qty`,`change_qty`,`after_qty`,`unit_cost`,`operator_id`,`occurred_at`,`remark`) VALUES
(9301,1,'ITX202604240001','PURCHASE_RECEIPT','GR202604240001','1',1,1002,5001,5202,6101,'BATCH-APPLE-20260424','GOOD',0.000000,118.000000,118.000000,28.000000,2003,'2026-04-24 10:35:00.000','采购收货入库'),
(9302,1,'ITX202604240002','PURCHASE_RETURN','PRTN202604240001','1',2,1002,5001,5202,6101,'BATCH-APPLE-20260424','GOOD',118.000000,2.000000,116.000000,28.000000,2003,'2026-04-24 10:50:00.000','采购退货出库'),
(9303,1,'ITX202604240003','SALES_DELIVERY','DO202604240001','1',2,1002,5001,5202,6101,'BATCH-APPLE-20260424','GOOD',116.000000,60.000000,56.000000,28.000000,2003,'2026-04-24 14:00:00.000','销售发货出库');

INSERT INTO `inventory_reservation` (`id`,`tenant_id`,`reservation_no`,`biz_type`,`biz_no`,`biz_line_no`,`org_id`,`warehouse_id`,`sku_id`,`batch_no`,`reserved_qty`,`released_qty`,`used_qty`,`status`,`expired_at`,`created_by`,`updated_by`,`remark`) VALUES
(9401,1,'RSV202604240001','SALES_ORDER','SO202604240001','1',1002,5001,6101,'BATCH-APPLE-20260424',80.000000,0.000000,60.000000,'ACTIVE','2026-04-25 11:00:00.000',2004,2004,'华美超市订单预占');

INSERT INTO `inventory_lock` (`id`,`tenant_id`,`lock_no`,`biz_type`,`biz_no`,`warehouse_id`,`sku_id`,`batch_no`,`lock_qty`,`unlock_qty`,`status`,`expired_at`,`created_by`,`updated_by`,`remark`) VALUES
(9501,1,'LOCK202604240001','QUALITY_HOLD','GR202604240001',5001,6101,'BATCH-APPLE-20260424',2.000000,2.000000,'RELEASED','2026-04-24 18:00:00.000',2003,2003,'质检不合格锁定');

INSERT INTO `inventory_snapshot_daily` (`id`,`tenant_id`,`snapshot_date`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`qty_on_hand`,`qty_available`,`qty_reserved`,`qty_locked`,`qty_in_transit`,`created_by`,`updated_by`,`remark`) VALUES
(9601,1,'2026-04-24',1002,5001,5202,6101,'BATCH-APPLE-20260424','GOOD',116.000000,36.000000,80.000000,0.000000,0.000000,1,1,'日终快照');

INSERT INTO `inventory_count_task` (`id`,`tenant_id`,`count_no`,`warehouse_id`,`count_type`,`scope_type`,`scope_json`,`status`,`approve_status`,`count_start_at`,`count_end_at`,`created_by`,`updated_by`,`remark`) VALUES
(9701,1,'CNT202604240001',5001,'CYCLE','SKU',JSON_OBJECT('skuIds',JSON_ARRAY(6101)),'COMPLETED','APPROVED','2026-04-24 18:00:00.000','2026-04-24 18:30:00.000',2003,2003,'苹果循环盘点');

INSERT INTO `inventory_count_line` (`id`,`tenant_id`,`count_task_id`,`line_no`,`location_id`,`sku_id`,`batch_no`,`system_qty`,`counted_qty`,`diff_qty`,`adjust_status`,`created_by`,`updated_by`,`remark`) VALUES
(9801,1,9701,1,5202,6101,'BATCH-APPLE-20260424',56.000000,56.000000,0.000000,'NOT_REQUIRED',2003,2003,'');

INSERT INTO `inventory_adjust_order` (`id`,`tenant_id`,`adjust_no`,`warehouse_id`,`adjust_type`,`status`,`approve_status`,`reason_code`,`created_by`,`updated_by`,`remark`) VALUES
(9901,1,'ADJ202604240001',5001,'PROFIT_LOSS','APPROVED','APPROVED','COUNT_DIFF',2003,2003,'盘点调整单-演示');

INSERT INTO `inventory_adjust_order_line` (`id`,`tenant_id`,`adjust_id`,`line_no`,`location_id`,`sku_id`,`batch_no`,`before_qty`,`adjust_qty`,`after_qty`,`unit_cost`,`created_by`,`updated_by`,`remark`) VALUES
(9911,1,9901,1,5202,6101,'BATCH-APPLE-20260424',56.000000,0.000000,56.000000,28.000000,2003,2003,'');

INSERT INTO `wms_inbound_order` (`id`,`tenant_id`,`inbound_no`,`biz_type`,`biz_no`,`warehouse_id`,`inbound_status`,`expected_at`,`completed_at`,`created_by`,`updated_by`,`remark`) VALUES
(10001,1,'IB202604240001','PURCHASE_RECEIPT','GR202604240001',5001,'COMPLETED','2026-04-24 10:00:00.000','2026-04-24 11:00:00.000',2003,2003,'采购收货入库单');

INSERT INTO `wms_inbound_order_line` (`id`,`tenant_id`,`inbound_id`,`line_no`,`sku_id`,`batch_no`,`expected_qty`,`received_qty`,`putaway_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10011,1,10001,1,6101,'BATCH-APPLE-20260424',120.000000,120.000000,118.000000,'COMPLETED',2003,2003,'');

INSERT INTO `wms_putaway_task` (`id`,`tenant_id`,`task_no`,`inbound_id`,`warehouse_id`,`task_status`,`assigned_to`,`start_at`,`finish_at`,`created_by`,`updated_by`,`remark`) VALUES
(10101,1,'PT202604240001',10001,5001,'DONE',2003,'2026-04-24 10:40:00.000','2026-04-24 10:55:00.000',2003,2003,'苹果上架任务');

INSERT INTO `wms_putaway_task_line` (`id`,`tenant_id`,`task_id`,`line_no`,`sku_id`,`batch_no`,`from_location_id`,`to_location_id`,`task_qty`,`done_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10111,1,10101,1,6101,'BATCH-APPLE-20260424',5201,5202,118.000000,118.000000,'DONE',2003,2003,'');

INSERT INTO `wms_outbound_order` (`id`,`tenant_id`,`outbound_no`,`biz_type`,`biz_no`,`warehouse_id`,`wave_no`,`outbound_status`,`completed_at`,`created_by`,`updated_by`,`remark`) VALUES
(10201,1,'OB202604240001','SALES_ORDER','SO202604240001',5001,'WAVE202604240001','PARTIAL','2026-04-24 14:10:00.000',2003,2003,'销售出库单');

INSERT INTO `wms_outbound_order_line` (`id`,`tenant_id`,`outbound_id`,`line_no`,`sku_id`,`batch_no`,`required_qty`,`allocated_qty`,`picked_qty`,`shipped_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10211,1,10201,1,6101,'BATCH-APPLE-20260424',100.000000,80.000000,60.000000,60.000000,'PARTIAL',2003,2003,'');

INSERT INTO `wms_pick_task` (`id`,`tenant_id`,`task_no`,`outbound_id`,`warehouse_id`,`pick_type`,`task_status`,`assigned_to`,`start_at`,`finish_at`,`created_by`,`updated_by`,`remark`) VALUES
(10301,1,'PK202604240001',10201,5001,'WAVE','DONE',2003,'2026-04-24 13:20:00.000','2026-04-24 13:50:00.000',2003,2003,'波次拣货任务');

INSERT INTO `wms_pick_task_line` (`id`,`tenant_id`,`task_id`,`line_no`,`sku_id`,`batch_no`,`from_location_id`,`pick_qty`,`picked_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10311,1,10301,1,6101,'BATCH-APPLE-20260424',5202,60.000000,60.000000,'DONE',2003,2003,'');

INSERT INTO `wms_wave` (`id`,`tenant_id`,`wave_no`,`warehouse_id`,`wave_type`,`wave_status`,`release_at`,`created_by`,`updated_by`,`remark`) VALUES
(10401,1,'WAVE202604240001',5001,'NORMAL','RELEASED','2026-04-24 13:00:00.000',2003,2003,'苹果订单波次');

INSERT INTO `wms_wave_order_rel` (`id`,`tenant_id`,`wave_id`,`outbound_id`,`created_by`,`updated_by`,`remark`) VALUES
(10411,1,10401,10201,2003,2003,'');

INSERT INTO `wms_transfer_order` (`id`,`tenant_id`,`transfer_no`,`from_warehouse_id`,`to_warehouse_id`,`status`,`approve_status`,`shipped_at`,`received_at`,`created_by`,`updated_by`,`remark`) VALUES
(10501,1,'TR202604240001',5001,5002,'SHIPPED','APPROVED','2026-04-24 16:00:00.000',NULL,2003,2003,'苹果跨仓调拨');

INSERT INTO `wms_transfer_order_line` (`id`,`tenant_id`,`transfer_id`,`line_no`,`sku_id`,`batch_no`,`transfer_qty`,`shipped_qty`,`received_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10511,1,10501,1,6101,'BATCH-APPLE-20260424',20.000000,20.000000,0.000000,'SHIPPED',2003,2003,'');

INSERT INTO `wms_move_order` (`id`,`tenant_id`,`move_no`,`warehouse_id`,`status`,`approve_status`,`created_by`,`updated_by`,`remark`) VALUES
(10601,1,'MV202604240001',5001,'DONE','APPROVED',2003,2003,'库内移位');

INSERT INTO `wms_move_order_line` (`id`,`tenant_id`,`move_id`,`line_no`,`sku_id`,`batch_no`,`from_location_id`,`to_location_id`,`move_qty`,`done_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10611,1,10601,1,6101,'BATCH-APPLE-20260424',5202,5203,10.000000,10.000000,'DONE',2003,2003,'');

INSERT INTO `settlement_ap_bill` (`id`,`tenant_id`,`bill_no`,`supplier_id`,`source_type`,`source_no`,`bill_amount`,`tax_amount`,`paid_amount`,`status`,`due_date`,`created_by`,`updated_by`,`remark`) VALUES
(11001,1,'AP202604240001',4001,'PURCHASE_ORDER','PO202604240001',6104.000000,504.000000,0.000000,'OPEN','2026-05-24',2002,2002,'苹果采购应付');

INSERT INTO `settlement_ar_bill` (`id`,`tenant_id`,`bill_no`,`customer_id`,`source_type`,`source_no`,`bill_amount`,`tax_amount`,`received_amount`,`status`,`due_date`,`created_by`,`updated_by`,`remark`) VALUES
(11101,1,'AR202604240001',4201,'SALES_ORDER','SO202604240001',4796.000000,396.000000,2000.000000,'PARTIAL','2026-05-24',2004,2004,'华美超市应收');

INSERT INTO `settlement_payment` (`id`,`tenant_id`,`payment_no`,`supplier_id`,`pay_type`,`currency`,`pay_amount`,`pay_time`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11201,1,'PAY202604240001',4001,'BANK','CNY',2000.000000,'2026-04-24 17:00:00.000','POSTED',2001,2001,'供应商预付款');

INSERT INTO `settlement_receipt` (`id`,`tenant_id`,`receipt_no`,`customer_id`,`receipt_type`,`currency`,`receipt_amount`,`receipt_time`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11301,1,'RCV202604240001',4201,'BANK','CNY',2000.000000,'2026-04-24 15:00:00.000','POSTED',2001,2001,'客户首款');

INSERT INTO `settlement_statement` (`id`,`tenant_id`,`statement_no`,`counterparty_type`,`counterparty_id`,`period_start`,`period_end`,`statement_amount`,`confirmed_amount`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11401,1,'STM202604240001','SUPPLIER',4001,'2026-04-01','2026-04-30',6104.000000,6104.000000,'CONFIRMED',2001,2001,'4月供应商对账单');

INSERT INTO `settlement_invoice` (`id`,`tenant_id`,`invoice_no`,`counterparty_type`,`counterparty_id`,`invoice_type`,`invoice_amount`,`tax_amount`,`invoice_date`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11501,1,'INV202604240001','CUSTOMER',4201,'VAT',4796.000000,396.000000,'2026-04-24','ISSUED',2001,2001,'销售发票');

INSERT INTO `workflow_instance` (`id`,`tenant_id`,`instance_no`,`biz_type`,`biz_no`,`status`,`current_node`,`start_user_id`,`start_at`,`end_at`,`created_by`,`updated_by`,`remark`) VALUES
(12001,1,'WF202604240001','PURCHASE_ORDER','PO202604240001','COMPLETED','END',2002,'2026-04-24 08:50:00.000','2026-04-24 09:00:00.000',2002,2002,'采购审批流程');

INSERT INTO `workflow_task` (`id`,`tenant_id`,`instance_id`,`node_code`,`task_name`,`assignee_id`,`task_status`,`action`,`action_at`,`comment`,`created_by`,`updated_by`,`remark`) VALUES
(12101,1,12001,'MANAGER_APPROVE','采购经理审批',2001,'DONE','APPROVE','2026-04-24 09:00:00.000','审批通过',2002,2002,'');

INSERT INTO `integration_idempotent` (`id`,`tenant_id`,`idempotent_key`,`biz_type`,`biz_no`,`request_hash`,`status`,`response_snapshot`,`expired_at`,`created_at`,`updated_at`) VALUES
(13001,1,'IDEMP-EXT-HMART-0001','SALES_ORDER','SO202604240001','sha256-demo-hmart-order','SUCCESS',JSON_OBJECT('soNo','SO202604240001','status','APPROVED'),'2026-05-24 00:00:00.000','2026-04-24 11:00:00.000','2026-04-24 11:00:00.000');

INSERT INTO `event_outbox` (`id`,`tenant_id`,`event_id`,`aggregate_type`,`aggregate_id`,`event_type`,`biz_no`,`payload_json`,`status`,`retry_count`,`next_retry_at`,`published_at`,`created_at`,`updated_at`) VALUES
(13101,1,'EVT-PO-7201-APPROVED','purchase_order','7201','purchase.order.approved','PO202604240001',JSON_OBJECT('poNo','PO202604240001','supplierId',4001),'PUBLISHED',0,NULL,'2026-04-24 09:05:00.000','2026-04-24 09:00:00.000','2026-04-24 09:05:00.000'),
(13102,1,'EVT-SO-8001-CREATED','sales_order','8001','sales.order.created','SO202604240001',JSON_OBJECT('soNo','SO202604240001','customerId',4201),'PUBLISHED',0,NULL,'2026-04-24 11:01:00.000','2026-04-24 11:00:00.000','2026-04-24 11:01:00.000');

INSERT INTO `integration_api_log` (`id`,`tenant_id`,`biz_type`,`biz_no`,`interface_name`,`direction`,`request_uri`,`request_body`,`response_body`,`status`,`error_msg`,`request_at`,`response_at`) VALUES
(13201,1,'SALES_ORDER','SO202604240001','hmart.order.push','IN','/api/open/orders',JSON_OBJECT('sourceOrderNo','EXT-HMART-0001','items',1),JSON_OBJECT('code',0,'message','ok'),'SUCCESS','', '2026-04-24 10:59:59.000','2026-04-24 11:00:00.000');

INSERT INTO `sys_audit_log` (`id`,`tenant_id`,`user_id`,`module`,`action`,`biz_type`,`biz_no`,`request_uri`,`request_ip`,`before_json`,`after_json`,`created_at`) VALUES
(14001,1,2002,'PURCHASE','CREATE_PO','PURCHASE_ORDER','PO202604240001','/api/purchase/orders','10.10.10.21',NULL,JSON_OBJECT('poNo','PO202604240001','status','APPROVED'),'2026-04-24 09:00:00.000'),
(14002,1,2004,'SALES','CREATE_SO','SALES_ORDER','SO202604240001','/api/sales/orders','10.10.10.22',NULL,JSON_OBJECT('soNo','SO202604240001','status','APPROVED'),'2026-04-24 11:00:00.000');

INSERT INTO `sys_login_log` (`id`,`tenant_id`,`user_id`,`username`,`login_ip`,`login_result`,`user_agent`,`created_at`) VALUES
(14101,1,2001,'admin','10.10.10.10','SUCCESS','Mozilla/5.0 DemoBrowser','2026-04-24 09:00:00.000'),
(14102,1,2004,'sales.east','10.10.10.22','SUCCESS','Mozilla/5.0 DemoBrowser','2026-04-24 09:30:00.000');

INSERT INTO `sys_operate_log` (`id`,`tenant_id`,`user_id`,`module`,`operate_type`,`request_method`,`request_uri`,`request_body`,`response_body`,`latency_ms`,`status`,`created_at`) VALUES
(14201,1,2003,'WMS','SHIP','POST','/api/wms/outbound/ship',JSON_OBJECT('outboundNo','OB202604240001'),JSON_OBJECT('code',0,'message','success'),126,'SUCCESS','2026-04-24 14:00:00.000'),
(14202,1,2001,'SETTLEMENT','RECEIPT','POST','/api/finance/receipt',JSON_OBJECT('receiptNo','RCV202604240001'),JSON_OBJECT('code',0,'message','success'),98,'SUCCESS','2026-04-24 15:00:00.000');

COMMIT;
