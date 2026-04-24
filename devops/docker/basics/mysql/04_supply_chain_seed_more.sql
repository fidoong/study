SET NAMES utf8mb4;
USE `supply_chain_center`;

START TRANSACTION;

INSERT INTO `mdm_supplier` (`id`,`tenant_id`,`supplier_code`,`supplier_name`,`supplier_type`,`supplier_level`,`contact_name`,`contact_mobile`,`contact_email`,`province`,`city`,`district`,`address`,`tax_no`,`bank_name`,`bank_account`,`settlement_type`,`payment_term`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4003,1,'SUP-VEG','绿田蔬菜农业合作社','MANUFACTURER','A','赵立新','13900000003','zhao@veg.com','山东省','寿光市','圣城街道','寿光现代农业园5号','91370000VEG003','农业银行寿光支行','6222000000000003','MONTHLY','15D','ENABLED',1,1,'蔬菜类供应商'),
(4004,1,'SUP-RICE','黑土地米业有限公司','MANUFACTURER','A','孙海涛','13900000004','sun@rice.com','黑龙江省','哈尔滨市','松北区','松北粮油产业园6号','91230000RICE004','工商银行哈尔滨分行','6222000000000004','MONTHLY','30D','ENABLED',1,1,'粮油供应商'),
(4005,1,'SUP-DRINK','清泉饮品股份有限公司','MANUFACTURER','B','马文静','13900000005','ma@drink.com','浙江省','杭州市','余杭区','余杭食品工业园3号','91330000DRINK005','招商银行杭州分行','6222000000000005','MONTHLY','45D','ENABLED',1,1,'饮品供应商');

INSERT INTO `mdm_supplier_contact` (`id`,`tenant_id`,`supplier_id`,`contact_name`,`mobile`,`email`,`position`,`is_default`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4103,1,4003,'赵立新','13900000003','zhao@veg.com','大客户经理',1,'ENABLED',1,1,''),
(4104,1,4004,'孙海涛','13900000004','sun@rice.com','销售总监',1,'ENABLED',1,1,''),
(4105,1,4005,'马文静','13900000005','ma@drink.com','区域经理',1,'ENABLED',1,1,'');

INSERT INTO `mdm_customer` (`id`,`tenant_id`,`customer_code`,`customer_name`,`customer_type`,`customer_level`,`contact_name`,`contact_mobile`,`contact_email`,`province`,`city`,`district`,`address`,`tax_no`,`settlement_type`,`payment_term`,`credit_limit`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4203,1,'CUS-FRESHGO','鲜购社区团购平台','ECOM','A','黄蓉','13700000003','huang@freshgo.com','北京市','北京市','朝阳区','朝阳区望京SOHO T2','91110000FRESH003','PREPAID','0D',300000.000000,'ENABLED',1,1,'社区团购平台'),
(4204,1,'CUS-UNI','优你便利连锁','RETAIL','B','何军','13700000004','he@uni.com','江苏省','南京市','江宁区','江宁开发区双龙大道68号','91320000UNI004','MONTHLY','15D',150000.000000,'ENABLED',1,1,'便利店渠道'),
(4205,1,'CUS-CAMPUS','学城校园后勤集团','B2B','A','蒋楠','13700000005','jiang@campus.com','湖北省','武汉市','洪山区','洪山区大学园路18号','91420000CAMPUS005','MONTHLY','30D',250000.000000,'ENABLED',1,1,'团餐客户');

INSERT INTO `mdm_customer_contact` (`id`,`tenant_id`,`customer_id`,`contact_name`,`mobile`,`email`,`position`,`is_default`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4303,1,4203,'黄蓉','13700000003','huang@freshgo.com','平台招商经理',1,'ENABLED',1,1,''),
(4304,1,4204,'何军','13700000004','he@uni.com','采购经理',1,'ENABLED',1,1,''),
(4305,1,4205,'蒋楠','13700000005','jiang@campus.com','餐饮采购总监',1,'ENABLED',1,1,'');

INSERT INTO `mdm_brand` (`id`,`tenant_id`,`brand_code`,`brand_name`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4403,1,'BR-FARM','田园鲜生','ENABLED',1,1,''),
(4404,1,'BR-SPRING','山泉时刻','ENABLED',1,1,'');

INSERT INTO `mdm_category` (`id`,`tenant_id`,`parent_id`,`category_code`,`category_name`,`category_level`,`path`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(4504,1,4501,'CAT-VEG','蔬菜',2,'/4501/4504/','ENABLED',1,1,''),
(4505,1,4501,'CAT-GRAIN','粮油',2,'/4501/4505/','ENABLED',1,1,''),
(4506,1,4501,'CAT-DRINK','饮品',2,'/4501/4506/','ENABLED',1,1,'');

INSERT INTO `mdm_warehouse` (`id`,`tenant_id`,`org_id`,`warehouse_code`,`warehouse_name`,`warehouse_type`,`warehouse_level`,`province`,`city`,`district`,`address`,`manager_id`,`phone`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5003,1,1001,'WH-BJ-RDC','北京区域仓','RDC','L2','北京市','北京市','通州区','通州物流基地C8',2003,'010-88880003','ENABLED',1,1,'华北区域仓');

INSERT INTO `mdm_warehouse_area` (`id`,`tenant_id`,`warehouse_id`,`area_code`,`area_name`,`area_type`,`temperature_type`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5104,1,5003,'A-BJ-STO','北京常温库区','STORAGE','NORMAL','ENABLED',1,1,''),
(5105,1,5003,'A-BJ-REC','北京收货区','RECEIVING','NORMAL','ENABLED',1,1,'');

INSERT INTO `mdm_location` (`id`,`tenant_id`,`warehouse_id`,`area_id`,`location_code`,`location_name`,`location_type`,`length`,`width`,`height`,`capacity_qty`,`is_pickable`,`is_locked`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(5205,1,5003,5105,'BJ-REC-01','北京收货位01','DOCK',2.000000,2.000000,2.500000,1200.000000,0,0,'ENABLED',1,1,''),
(5206,1,5003,5104,'BJ-A01-01','北京货架A01-01','SHELF',1.200000,0.800000,2.000000,600.000000,1,0,'ENABLED',1,1,''),
(5207,1,5003,5104,'BJ-A01-02','北京货架A01-02','SHELF',1.200000,0.800000,2.000000,600.000000,1,0,'ENABLED',1,1,'');

INSERT INTO `product_spu` (`id`,`tenant_id`,`spu_code`,`spu_name`,`category_id`,`brand_id`,`product_type`,`status`,`attr_json`,`created_by`,`updated_by`,`remark`) VALUES
(6003,1,'SPU-TOMATO','精品番茄',4504,4403,'NORMAL','ENABLED',JSON_OBJECT('origin','山东寿光','grade','精选'),1,1,''),
(6004,1,'SPU-RICE','东北五常大米',4505,4403,'NORMAL','ENABLED',JSON_OBJECT('origin','黑龙江','year','新米'),1,1,''),
(6005,1,'SPU-WATER','天然矿泉水',4506,4404,'NORMAL','ENABLED',JSON_OBJECT('origin','长白山','gas','none'),1,1,''),
(6006,1,'SPU-YOGURT','低糖酸奶',4503,4402,'NORMAL','ENABLED',JSON_OBJECT('origin','河北','sugar','low'),1,1,'');

INSERT INTO `product_sku` (`id`,`tenant_id`,`spu_id`,`sku_code`,`sku_name`,`barcode`,`spec_json`,`base_unit_id`,`assist_unit_id`,`unit_convert_rate`,`weight`,`volume`,`length`,`width`,`height`,`cost_price`,`sale_price`,`tax_rate_id`,`batch_required`,`serial_required`,`shelf_life_days`,`enable_negative_stock`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6103,1,6003,'SKU-TOMATO-5KG','精品番茄 5KG/箱','690100000003',JSON_OBJECT('package','5KG/箱','grade','精选'),4602,4603,5.000000,5.000000,0.017000,0.420000,0.300000,0.140000,22.000000,36.000000,4701,1,0,15,0,'ENABLED',1,1,''),
(6104,1,6004,'SKU-RICE-10KG','东北五常大米 10KG/袋','690100000004',JSON_OBJECT('package','10KG/袋','riceType','五常'),4602,4603,10.000000,10.000000,0.022000,0.450000,0.320000,0.120000,58.000000,79.000000,4701,1,0,365,0,'ENABLED',1,1,''),
(6105,1,6005,'SKU-WATER-550ML-24','天然矿泉水 550ML*24','690100000005',JSON_OBJECT('package','550ML*24','waterType','spring'),4602,4601,24.000000,13.200000,0.028000,0.400000,0.270000,0.220000,18.000000,29.900000,4702,1,0,365,0,'ENABLED',1,1,''),
(6106,1,6006,'SKU-YOGURT-200G-12','低糖酸奶 200G*12','690100000006',JSON_OBJECT('package','200G*12','temperature','冷藏'),4602,4601,12.000000,2.600000,0.014000,0.310000,0.210000,0.120000,26.000000,42.000000,4702,1,0,21,0,'ENABLED',1,1,'');

INSERT INTO `product_sku_barcode` (`id`,`tenant_id`,`sku_id`,`barcode`,`barcode_type`,`is_primary`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6203,1,6103,'690100000003','EAN13',1,'ENABLED',1,1,''),
(6204,1,6104,'690100000004','EAN13',1,'ENABLED',1,1,''),
(6205,1,6105,'690100000005','EAN13',1,'ENABLED',1,1,''),
(6206,1,6106,'690100000006','EAN13',1,'ENABLED',1,1,'');

INSERT INTO `product_sku_attr` (`id`,`tenant_id`,`sku_id`,`attr_code`,`attr_name`,`attr_value`,`created_by`,`updated_by`,`remark`) VALUES
(6304,1,6103,'ORIGIN','产地','山东寿光',1,1,''),
(6305,1,6104,'LEVEL','等级','一级',1,1,''),
(6306,1,6105,'SOURCE','水源','长白山泉水',1,1,''),
(6307,1,6106,'TEMP','温层','2-6摄氏度',1,1,'');

INSERT INTO `product_price` (`id`,`tenant_id`,`sku_id`,`price_type`,`org_id`,`customer_id`,`currency`,`price`,`effective_from`,`effective_to`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(6405,1,6103,'SALE',1002,0,'CNY',36.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6406,1,6103,'PURCHASE',1002,0,'CNY',22.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6407,1,6104,'SALE',1001,0,'CNY',79.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6408,1,6104,'PURCHASE',1001,0,'CNY',58.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6409,1,6105,'SALE',1001,0,'CNY',29.900000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6410,1,6105,'PURCHASE',1001,0,'CNY',18.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6411,1,6106,'SALE',1003,0,'CNY',42.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,''),
(6412,1,6106,'PURCHASE',1003,0,'CNY',26.000000,'2026-01-01 00:00:00.000',NULL,'ENABLED',1,1,'');

INSERT INTO `purchase_requisition` (`id`,`tenant_id`,`req_no`,`org_id`,`req_type`,`req_status`,`approve_status`,`required_date`,`applicant_id`,`total_amount`,`created_by`,`updated_by`,`remark`) VALUES
(7002,1,'PR202604240002',1002,'NORMAL','APPROVED','APPROVED','2026-04-29',2002,4400.000000,2002,2002,'番茄补货申请'),
(7003,1,'PR202604240003',1001,'NORMAL','APPROVED','APPROVED','2026-04-30',2002,6960.000000,2002,2002,'大米备货申请'),
(7004,1,'PR202604240004',1003,'NORMAL','APPROVED','APPROVED','2026-04-29',2002,2600.000000,2002,2002,'酸奶冷链补货');

INSERT INTO `purchase_requisition_line` (`id`,`tenant_id`,`req_id`,`line_no`,`sku_id`,`unit_id`,`req_qty`,`converted_qty`,`estimated_price`,`estimated_amount`,`required_date`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7102,1,7002,1,6103,4602,200.000000,1000.000000,22.000000,4400.000000,'2026-04-29','OPEN',2002,2002,''),
(7103,1,7003,1,6104,4602,120.000000,1200.000000,58.000000,6960.000000,'2026-04-30','OPEN',2002,2002,''),
(7104,1,7004,1,6106,4602,100.000000,1200.000000,26.000000,2600.000000,'2026-04-29','OPEN',2002,2002,'');

INSERT INTO `purchase_order` (`id`,`tenant_id`,`po_no`,`org_id`,`supplier_id`,`warehouse_id`,`source_type`,`source_no`,`currency`,`po_status`,`approve_status`,`delivery_status`,`expected_arrival_date`,`total_amount`,`discount_amount`,`tax_amount`,`payable_amount`,`created_by`,`updated_by`,`remark`) VALUES
(7203,1,'PO202604240003',1002,4003,5001,'REQUISITION','PR202604240002','CNY','APPROVED','APPROVED','COMPLETED','2026-04-25',4400.000000,0.000000,396.000000,4796.000000,2002,2002,'番茄采购单'),
(7204,1,'PO202604240004',1001,4004,5003,'REQUISITION','PR202604240003','CNY','APPROVED','APPROVED','PARTIAL','2026-04-26',6960.000000,0.000000,626.400000,7586.400000,2002,2002,'大米采购单'),
(7205,1,'PO202604240005',1003,4002,5002,'REQUISITION','PR202604240004','CNY','APPROVED','APPROVED','COMPLETED','2026-04-25',2600.000000,0.000000,338.000000,2938.000000,2002,2002,'酸奶采购单'),
(7206,1,'PO202604240006',1001,4005,5003,'MANUAL','','CNY','APPROVED','APPROVED','COMPLETED','2026-04-25',3600.000000,0.000000,468.000000,4068.000000,2002,2002,'矿泉水备货');

INSERT INTO `purchase_order_line` (`id`,`tenant_id`,`po_id`,`line_no`,`source_line_id`,`sku_id`,`unit_id`,`order_qty`,`received_qty`,`returned_qty`,`pending_qty`,`unit_price`,`discount_amount`,`tax_rate`,`tax_amount`,`line_amount`,`delivery_date`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7303,1,7203,1,7102,6103,4602,200.000000,200.000000,0.000000,0.000000,22.000000,0.000000,0.0900,396.000000,4400.000000,'2026-04-25','COMPLETED',2002,2002,''),
(7304,1,7204,1,7103,6104,4602,120.000000,80.000000,0.000000,40.000000,58.000000,0.000000,0.0900,626.400000,6960.000000,'2026-04-26','OPEN',2002,2002,''),
(7305,1,7205,1,7104,6106,4602,100.000000,100.000000,0.000000,0.000000,26.000000,0.000000,0.1300,338.000000,2600.000000,'2026-04-25','COMPLETED',2002,2002,''),
(7306,1,7206,1,0,6105,4602,200.000000,200.000000,0.000000,0.000000,18.000000,0.000000,0.1300,468.000000,3600.000000,'2026-04-25','COMPLETED',2002,2002,'');

INSERT INTO `purchase_receipt` (`id`,`tenant_id`,`receipt_no`,`po_id`,`supplier_id`,`warehouse_id`,`receipt_status`,`qc_status`,`received_at`,`created_by`,`updated_by`,`remark`) VALUES
(7402,1,'GR202604240002',7203,4003,5001,'COMPLETED','PASSED','2026-04-24 12:30:00.000',2003,2003,'番茄到货'),
(7403,1,'GR202604240003',7204,4004,5003,'COMPLETED','PASSED','2026-04-24 16:30:00.000',2003,2003,'大米首批到货'),
(7404,1,'GR202604240004',7205,4002,5002,'COMPLETED','PASSED','2026-04-24 17:30:00.000',2003,2003,'酸奶到货'),
(7405,1,'GR202604240005',7206,4005,5003,'COMPLETED','PASSED','2026-04-24 18:00:00.000',2003,2003,'矿泉水到货');

INSERT INTO `purchase_receipt_line` (`id`,`tenant_id`,`receipt_id`,`line_no`,`po_line_id`,`sku_id`,`batch_no`,`production_date`,`expire_date`,`received_qty`,`qualified_qty`,`rejected_qty`,`unit_cost`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(7502,1,7402,1,7303,6103,'BATCH-TOMATO-20260424','2026-04-24','2026-05-09',200.000000,198.000000,2.000000,22.000000,'COMPLETED',2003,2003,''),
(7503,1,7403,1,7304,6104,'BATCH-RICE-20260424','2026-04-20','2027-04-19',80.000000,80.000000,0.000000,58.000000,'COMPLETED',2003,2003,''),
(7504,1,7404,1,7305,6106,'BATCH-YOGURT-20260424','2026-04-24','2026-05-15',100.000000,99.000000,1.000000,26.000000,'COMPLETED',2003,2003,''),
(7505,1,7405,1,7306,6105,'BATCH-WATER-20260424','2026-04-24','2027-04-23',200.000000,200.000000,0.000000,18.000000,'COMPLETED',2003,2003,'');

INSERT INTO `sales_order` (`id`,`tenant_id`,`so_no`,`org_id`,`customer_id`,`warehouse_id`,`channel_type`,`source_order_no`,`sales_type`,`order_status`,`approve_status`,`payment_status`,`delivery_status`,`currency`,`total_amount`,`discount_amount`,`tax_amount`,`payable_amount`,`order_time`,`created_by`,`updated_by`,`remark`) VALUES
(8003,1,'SO202604240003',1002,4203,5001,'ECOM','EXT-FRESHGO-0001','NORMAL','APPROVED','APPROVED','PAID','SHIPPED','CNY',3600.000000,0.000000,324.000000,3924.000000,'2026-04-24 12:00:00.000',2004,2004,'社区团购番茄订单'),
(8004,1,'SO202604240004',1001,4204,5003,'RETAIL','EXT-UNI-0001','NORMAL','APPROVED','APPROVED','PARTIAL','PARTIAL','CNY',6320.000000,80.000000,561.600000,6801.600000,'2026-04-24 12:20:00.000',2004,2004,'便利店大米订单'),
(8005,1,'SO202604240005',1003,4205,5002,'B2B','EXT-CAMPUS-0001','NORMAL','APPROVED','APPROVED','UNPAID','SHIPPED','CNY',4200.000000,0.000000,546.000000,4746.000000,'2026-04-24 12:40:00.000',2004,2004,'校园酸奶订单'),
(8006,1,'SO202604240006',1001,4203,5003,'ECOM','EXT-FRESHGO-0002','NORMAL','APPROVED','APPROVED','PAID','SHIPPED','CNY',2990.000000,0.000000,388.700000,3378.700000,'2026-04-24 13:00:00.000',2004,2004,'社区团购矿泉水订单'),
(8007,1,'SO202604240007',1001,4205,5003,'B2B','EXT-CAMPUS-0002','NORMAL','APPROVED','APPROVED','UNPAID','PENDING','CNY',1580.000000,0.000000,142.200000,1722.200000,'2026-04-24 13:20:00.000',2004,2004,'校园大米追加订单');

INSERT INTO `sales_order_line` (`id`,`tenant_id`,`so_id`,`line_no`,`sku_id`,`unit_id`,`order_qty`,`allocated_qty`,`shipped_qty`,`returned_qty`,`pending_qty`,`unit_price`,`discount_amount`,`tax_rate`,`tax_amount`,`line_amount`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(8103,1,8003,1,6103,4602,100.000000,100.000000,100.000000,0.000000,0.000000,36.000000,0.000000,0.0900,324.000000,3600.000000,'COMPLETED',2004,2004,''),
(8104,1,8004,1,6104,4602,80.000000,60.000000,40.000000,0.000000,40.000000,79.000000,80.000000,0.0900,561.600000,6320.000000,'OPEN',2004,2004,''),
(8105,1,8005,1,6106,4602,100.000000,100.000000,100.000000,0.000000,0.000000,42.000000,0.000000,0.1300,546.000000,4200.000000,'COMPLETED',2004,2004,''),
(8106,1,8006,1,6105,4602,100.000000,100.000000,100.000000,0.000000,0.000000,29.900000,0.000000,0.1300,388.700000,2990.000000,'COMPLETED',2004,2004,''),
(8107,1,8007,1,6104,4602,20.000000,0.000000,0.000000,0.000000,20.000000,79.000000,0.000000,0.0900,142.200000,1580.000000,'OPEN',2004,2004,'');

INSERT INTO `sales_delivery_order` (`id`,`tenant_id`,`delivery_no`,`so_id`,`customer_id`,`warehouse_id`,`delivery_status`,`shipped_at`,`carrier_id`,`tracking_no`,`created_by`,`updated_by`,`remark`) VALUES
(8202,1,'DO202604240002',8003,4203,5001,'SHIPPED','2026-04-24 15:00:00.000',9002,'SF202604240002',2003,2003,'番茄发货'),
(8203,1,'DO202604240003',8005,4205,5002,'SHIPPED','2026-04-24 18:30:00.000',9003,'JD202604240003',2003,2003,'酸奶发货'),
(8204,1,'DO202604240004',8006,4203,5003,'SHIPPED','2026-04-24 18:50:00.000',9002,'SF202604240004',2003,2003,'矿泉水发货'),
(8205,1,'DO202604240005',8004,4204,5003,'PARTIAL_SHIPPED','2026-04-24 19:00:00.000',9004,'YT202604240005',2003,2003,'大米首批发货');

INSERT INTO `sales_delivery_order_line` (`id`,`tenant_id`,`delivery_id`,`line_no`,`so_line_id`,`sku_id`,`batch_no`,`delivery_qty`,`signed_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(8302,1,8202,1,8103,6103,'BATCH-TOMATO-20260424',100.000000,0.000000,'OPEN',2003,2003,''),
(8303,1,8203,1,8105,6106,'BATCH-YOGURT-20260424',100.000000,0.000000,'OPEN',2003,2003,''),
(8304,1,8204,1,8106,6105,'BATCH-WATER-20260424',100.000000,0.000000,'OPEN',2003,2003,''),
(8305,1,8205,1,8104,6104,'BATCH-RICE-20260424',40.000000,0.000000,'OPEN',2003,2003,'');

INSERT INTO `inventory_stock` (`id`,`tenant_id`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`owner_type`,`owner_id`,`qty_on_hand`,`qty_available`,`qty_reserved`,`qty_locked`,`qty_in_transit`,`qty_damaged`,`last_txn_time`,`version`,`updated_at`) VALUES
(9003,1,1002,5001,5203,6103,'BATCH-TOMATO-20260424','GOOD','SELF',0,198.000000,98.000000,100.000000,0.000000,0.000000,0.000000,'2026-04-24 15:00:00.000',2,'2026-04-24 15:00:00.000'),
(9004,1,1001,5003,5206,6104,'BATCH-RICE-20260424','GOOD','SELF',0,80.000000,40.000000,40.000000,0.000000,0.000000,0.000000,'2026-04-24 19:00:00.000',2,'2026-04-24 19:00:00.000'),
(9005,1,1003,5002,5204,6106,'BATCH-YOGURT-20260424','GOOD','SELF',0,99.000000,0.000000,0.000000,0.000000,0.000000,0.000000,'2026-04-24 18:30:00.000',2,'2026-04-24 18:30:00.000'),
(9006,1,1001,5003,5207,6105,'BATCH-WATER-20260424','GOOD','SELF',0,200.000000,100.000000,0.000000,0.000000,0.000000,0.000000,'2026-04-24 18:50:00.000',2,'2026-04-24 18:50:00.000');

INSERT INTO `inventory_batch` (`id`,`tenant_id`,`warehouse_id`,`sku_id`,`batch_no`,`production_date`,`expire_date`,`supplier_id`,`receipt_no`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(9103,1,5001,6103,'BATCH-TOMATO-20260424','2026-04-24','2026-05-09',4003,'GR202604240002','ENABLED',2003,2003,''),
(9104,1,5003,6104,'BATCH-RICE-20260424','2026-04-20','2027-04-19',4004,'GR202604240003','ENABLED',2003,2003,''),
(9105,1,5002,6106,'BATCH-YOGURT-20260424','2026-04-24','2026-05-15',4002,'GR202604240004','ENABLED',2003,2003,''),
(9106,1,5003,6105,'BATCH-WATER-20260424','2026-04-24','2027-04-23',4005,'GR202604240005','ENABLED',2003,2003,'');

INSERT INTO `inventory_txn` (`id`,`tenant_id`,`txn_no`,`biz_type`,`biz_no`,`biz_line_no`,`direction`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`before_qty`,`change_qty`,`after_qty`,`unit_cost`,`operator_id`,`occurred_at`,`remark`) VALUES
(9304,1,'ITX202604240004','PURCHASE_RECEIPT','GR202604240002','1',1,1002,5001,5203,6103,'BATCH-TOMATO-20260424','GOOD',0.000000,198.000000,198.000000,22.000000,2003,'2026-04-24 12:35:00.000','番茄采购入库'),
(9305,1,'ITX202604240005','PURCHASE_RECEIPT','GR202604240003','1',1,1001,5003,5206,6104,'BATCH-RICE-20260424','GOOD',0.000000,80.000000,80.000000,58.000000,2003,'2026-04-24 16:35:00.000','大米采购入库'),
(9306,1,'ITX202604240006','PURCHASE_RECEIPT','GR202604240004','1',1,1003,5002,5204,6106,'BATCH-YOGURT-20260424','GOOD',0.000000,99.000000,99.000000,26.000000,2003,'2026-04-24 17:35:00.000','酸奶采购入库'),
(9307,1,'ITX202604240007','PURCHASE_RECEIPT','GR202604240005','1',1,1001,5003,5207,6105,'BATCH-WATER-20260424','GOOD',0.000000,200.000000,200.000000,18.000000,2003,'2026-04-24 18:05:00.000','矿泉水采购入库'),
(9308,1,'ITX202604240008','SALES_DELIVERY','DO202604240002','1',2,1002,5001,5203,6103,'BATCH-TOMATO-20260424','GOOD',198.000000,100.000000,98.000000,22.000000,2003,'2026-04-24 15:00:00.000','番茄销售出库'),
(9309,1,'ITX202604240009','SALES_DELIVERY','DO202604240003','1',2,1003,5002,5204,6106,'BATCH-YOGURT-20260424','GOOD',99.000000,99.000000,0.000000,26.000000,2003,'2026-04-24 18:30:00.000','酸奶销售出库'),
(9310,1,'ITX202604240010','SALES_DELIVERY','DO202604240004','1',2,1001,5003,5207,6105,'BATCH-WATER-20260424','GOOD',200.000000,100.000000,100.000000,18.000000,2003,'2026-04-24 18:50:00.000','矿泉水销售出库'),
(9311,1,'ITX202604240011','SALES_DELIVERY','DO202604240005','1',2,1001,5003,5206,6104,'BATCH-RICE-20260424','GOOD',80.000000,40.000000,40.000000,58.000000,2003,'2026-04-24 19:00:00.000','大米首批出库');

INSERT INTO `inventory_reservation` (`id`,`tenant_id`,`reservation_no`,`biz_type`,`biz_no`,`biz_line_no`,`org_id`,`warehouse_id`,`sku_id`,`batch_no`,`reserved_qty`,`released_qty`,`used_qty`,`status`,`expired_at`,`created_by`,`updated_by`,`remark`) VALUES
(9402,1,'RSV202604240002','SALES_ORDER','SO202604240003','1',1002,5001,6103,'BATCH-TOMATO-20260424',100.000000,0.000000,100.000000,'USED','2026-04-25 12:00:00.000',2004,2004,''),
(9403,1,'RSV202604240003','SALES_ORDER','SO202604240004','1',1001,5003,6104,'BATCH-RICE-20260424',40.000000,0.000000,40.000000,'ACTIVE','2026-04-25 12:20:00.000',2004,2004,''),
(9404,1,'RSV202604240004','SALES_ORDER','SO202604240005','1',1003,5002,6106,'BATCH-YOGURT-20260424',100.000000,1.000000,99.000000,'USED','2026-04-25 12:40:00.000',2004,2004,''),
(9405,1,'RSV202604240005','SALES_ORDER','SO202604240006','1',1001,5003,6105,'BATCH-WATER-20260424',100.000000,0.000000,100.000000,'USED','2026-04-25 13:00:00.000',2004,2004,'');

INSERT INTO `inventory_snapshot_daily` (`id`,`tenant_id`,`snapshot_date`,`org_id`,`warehouse_id`,`location_id`,`sku_id`,`batch_no`,`stock_status`,`qty_on_hand`,`qty_available`,`qty_reserved`,`qty_locked`,`qty_in_transit`,`created_by`,`updated_by`,`remark`) VALUES
(9602,1,'2026-04-24',1002,5001,5203,6103,'BATCH-TOMATO-20260424','GOOD',198.000000,98.000000,100.000000,0.000000,0.000000,1,1,''),
(9603,1,'2026-04-24',1001,5003,5206,6104,'BATCH-RICE-20260424','GOOD',80.000000,40.000000,40.000000,0.000000,0.000000,1,1,''),
(9604,1,'2026-04-24',1003,5002,5204,6106,'BATCH-YOGURT-20260424','GOOD',99.000000,0.000000,0.000000,0.000000,0.000000,1,1,''),
(9605,1,'2026-04-24',1001,5003,5207,6105,'BATCH-WATER-20260424','GOOD',200.000000,100.000000,0.000000,0.000000,0.000000,1,1,'');

INSERT INTO `wms_inbound_order` (`id`,`tenant_id`,`inbound_no`,`biz_type`,`biz_no`,`warehouse_id`,`inbound_status`,`expected_at`,`completed_at`,`created_by`,`updated_by`,`remark`) VALUES
(10002,1,'IB202604240002','PURCHASE_RECEIPT','GR202604240002',5001,'COMPLETED','2026-04-24 12:00:00.000','2026-04-24 12:45:00.000',2003,2003,''),
(10003,1,'IB202604240003','PURCHASE_RECEIPT','GR202604240003',5003,'COMPLETED','2026-04-24 16:00:00.000','2026-04-24 16:45:00.000',2003,2003,''),
(10004,1,'IB202604240004','PURCHASE_RECEIPT','GR202604240004',5002,'COMPLETED','2026-04-24 17:00:00.000','2026-04-24 17:50:00.000',2003,2003,''),
(10005,1,'IB202604240005','PURCHASE_RECEIPT','GR202604240005',5003,'COMPLETED','2026-04-24 17:30:00.000','2026-04-24 18:10:00.000',2003,2003,'');

INSERT INTO `wms_inbound_order_line` (`id`,`tenant_id`,`inbound_id`,`line_no`,`sku_id`,`batch_no`,`expected_qty`,`received_qty`,`putaway_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10012,1,10002,1,6103,'BATCH-TOMATO-20260424',200.000000,200.000000,198.000000,'COMPLETED',2003,2003,''),
(10013,1,10003,1,6104,'BATCH-RICE-20260424',80.000000,80.000000,80.000000,'COMPLETED',2003,2003,''),
(10014,1,10004,1,6106,'BATCH-YOGURT-20260424',100.000000,100.000000,99.000000,'COMPLETED',2003,2003,''),
(10015,1,10005,1,6105,'BATCH-WATER-20260424',200.000000,200.000000,200.000000,'COMPLETED',2003,2003,'');

INSERT INTO `wms_putaway_task` (`id`,`tenant_id`,`task_no`,`inbound_id`,`warehouse_id`,`task_status`,`assigned_to`,`start_at`,`finish_at`,`created_by`,`updated_by`,`remark`) VALUES
(10102,1,'PT202604240002',10002,5001,'DONE',2003,'2026-04-24 12:20:00.000','2026-04-24 12:40:00.000',2003,2003,''),
(10103,1,'PT202604240003',10003,5003,'DONE',2003,'2026-04-24 16:20:00.000','2026-04-24 16:40:00.000',2003,2003,''),
(10104,1,'PT202604240004',10004,5002,'DONE',2003,'2026-04-24 17:20:00.000','2026-04-24 17:45:00.000',2003,2003,''),
(10105,1,'PT202604240005',10005,5003,'DONE',2003,'2026-04-24 17:45:00.000','2026-04-24 18:05:00.000',2003,2003,'');

INSERT INTO `wms_putaway_task_line` (`id`,`tenant_id`,`task_id`,`line_no`,`sku_id`,`batch_no`,`from_location_id`,`to_location_id`,`task_qty`,`done_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10112,1,10102,1,6103,'BATCH-TOMATO-20260424',5201,5203,198.000000,198.000000,'DONE',2003,2003,''),
(10113,1,10103,1,6104,'BATCH-RICE-20260424',5205,5206,80.000000,80.000000,'DONE',2003,2003,''),
(10114,1,10104,1,6106,'BATCH-YOGURT-20260424',5204,5204,99.000000,99.000000,'DONE',2003,2003,''),
(10115,1,10105,1,6105,'BATCH-WATER-20260424',5205,5207,200.000000,200.000000,'DONE',2003,2003,'');

INSERT INTO `wms_outbound_order` (`id`,`tenant_id`,`outbound_no`,`biz_type`,`biz_no`,`warehouse_id`,`wave_no`,`outbound_status`,`completed_at`,`created_by`,`updated_by`,`remark`) VALUES
(10202,1,'OB202604240002','SALES_ORDER','SO202604240003',5001,'WAVE202604240002','COMPLETED','2026-04-24 15:10:00.000',2003,2003,''),
(10203,1,'OB202604240003','SALES_ORDER','SO202604240005',5002,'WAVE202604240003','COMPLETED','2026-04-24 18:35:00.000',2003,2003,''),
(10204,1,'OB202604240004','SALES_ORDER','SO202604240006',5003,'WAVE202604240004','COMPLETED','2026-04-24 18:55:00.000',2003,2003,''),
(10205,1,'OB202604240005','SALES_ORDER','SO202604240004',5003,'WAVE202604240005','PARTIAL','2026-04-24 19:05:00.000',2003,2003,'');

INSERT INTO `wms_outbound_order_line` (`id`,`tenant_id`,`outbound_id`,`line_no`,`sku_id`,`batch_no`,`required_qty`,`allocated_qty`,`picked_qty`,`shipped_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10212,1,10202,1,6103,'BATCH-TOMATO-20260424',100.000000,100.000000,100.000000,100.000000,'COMPLETED',2003,2003,''),
(10213,1,10203,1,6106,'BATCH-YOGURT-20260424',100.000000,100.000000,100.000000,100.000000,'COMPLETED',2003,2003,''),
(10214,1,10204,1,6105,'BATCH-WATER-20260424',100.000000,100.000000,100.000000,100.000000,'COMPLETED',2003,2003,''),
(10215,1,10205,1,6104,'BATCH-RICE-20260424',80.000000,40.000000,40.000000,40.000000,'PARTIAL',2003,2003,'');

INSERT INTO `wms_pick_task` (`id`,`tenant_id`,`task_no`,`outbound_id`,`warehouse_id`,`pick_type`,`task_status`,`assigned_to`,`start_at`,`finish_at`,`created_by`,`updated_by`,`remark`) VALUES
(10302,1,'PK202604240002',10202,5001,'WAVE','DONE',2003,'2026-04-24 14:30:00.000','2026-04-24 14:50:00.000',2003,2003,''),
(10303,1,'PK202604240003',10203,5002,'SINGLE','DONE',2003,'2026-04-24 18:00:00.000','2026-04-24 18:20:00.000',2003,2003,''),
(10304,1,'PK202604240004',10204,5003,'SINGLE','DONE',2003,'2026-04-24 18:20:00.000','2026-04-24 18:40:00.000',2003,2003,''),
(10305,1,'PK202604240005',10205,5003,'WAVE','DONE',2003,'2026-04-24 18:40:00.000','2026-04-24 18:55:00.000',2003,2003,'');

INSERT INTO `wms_pick_task_line` (`id`,`tenant_id`,`task_id`,`line_no`,`sku_id`,`batch_no`,`from_location_id`,`pick_qty`,`picked_qty`,`line_status`,`created_by`,`updated_by`,`remark`) VALUES
(10312,1,10302,1,6103,'BATCH-TOMATO-20260424',5203,100.000000,100.000000,'DONE',2003,2003,''),
(10313,1,10303,1,6106,'BATCH-YOGURT-20260424',5204,100.000000,100.000000,'DONE',2003,2003,''),
(10314,1,10304,1,6105,'BATCH-WATER-20260424',5207,100.000000,100.000000,'DONE',2003,2003,''),
(10315,1,10305,1,6104,'BATCH-RICE-20260424',5206,40.000000,40.000000,'DONE',2003,2003,'');

INSERT INTO `wms_wave` (`id`,`tenant_id`,`wave_no`,`warehouse_id`,`wave_type`,`wave_status`,`release_at`,`created_by`,`updated_by`,`remark`) VALUES
(10402,1,'WAVE202604240002',5001,'NORMAL','RELEASED','2026-04-24 14:20:00.000',2003,2003,''),
(10403,1,'WAVE202604240003',5002,'NORMAL','RELEASED','2026-04-24 17:55:00.000',2003,2003,''),
(10404,1,'WAVE202604240004',5003,'NORMAL','RELEASED','2026-04-24 18:15:00.000',2003,2003,''),
(10405,1,'WAVE202604240005',5003,'NORMAL','RELEASED','2026-04-24 18:35:00.000',2003,2003,'');

INSERT INTO `wms_wave_order_rel` (`id`,`tenant_id`,`wave_id`,`outbound_id`,`created_by`,`updated_by`,`remark`) VALUES
(10412,1,10402,10202,2003,2003,''),
(10413,1,10403,10203,2003,2003,''),
(10414,1,10404,10204,2003,2003,''),
(10415,1,10405,10205,2003,2003,'');

INSERT INTO `settlement_ap_bill` (`id`,`tenant_id`,`bill_no`,`supplier_id`,`source_type`,`source_no`,`bill_amount`,`tax_amount`,`paid_amount`,`status`,`due_date`,`created_by`,`updated_by`,`remark`) VALUES
(11002,1,'AP202604240002',4003,'PURCHASE_ORDER','PO202604240003',4796.000000,396.000000,0.000000,'OPEN','2026-05-24',2002,2002,''),
(11003,1,'AP202604240003',4004,'PURCHASE_ORDER','PO202604240004',7586.400000,626.400000,0.000000,'OPEN','2026-05-24',2002,2002,''),
(11004,1,'AP202604240004',4002,'PURCHASE_ORDER','PO202604240005',2938.000000,338.000000,0.000000,'OPEN','2026-05-24',2002,2002,''),
(11005,1,'AP202604240005',4005,'PURCHASE_ORDER','PO202604240006',4068.000000,468.000000,0.000000,'OPEN','2026-05-24',2002,2002,'');

INSERT INTO `settlement_ar_bill` (`id`,`tenant_id`,`bill_no`,`customer_id`,`source_type`,`source_no`,`bill_amount`,`tax_amount`,`received_amount`,`status`,`due_date`,`created_by`,`updated_by`,`remark`) VALUES
(11102,1,'AR202604240002',4203,'SALES_ORDER','SO202604240003',3924.000000,324.000000,3924.000000,'CLOSED','2026-05-24',2004,2004,''),
(11103,1,'AR202604240003',4204,'SALES_ORDER','SO202604240004',6801.600000,561.600000,2000.000000,'PARTIAL','2026-05-24',2004,2004,''),
(11104,1,'AR202604240004',4205,'SALES_ORDER','SO202604240005',4746.000000,546.000000,0.000000,'OPEN','2026-05-24',2004,2004,''),
(11105,1,'AR202604240005',4203,'SALES_ORDER','SO202604240006',3378.700000,388.700000,3378.700000,'CLOSED','2026-05-24',2004,2004,'');

INSERT INTO `settlement_payment` (`id`,`tenant_id`,`payment_no`,`supplier_id`,`pay_type`,`currency`,`pay_amount`,`pay_time`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11202,1,'PAY202604240002',4003,'BANK','CNY',1000.000000,'2026-04-24 18:10:00.000','POSTED',2001,2001,''),
(11203,1,'PAY202604240003',4005,'BANK','CNY',1500.000000,'2026-04-24 18:20:00.000','POSTED',2001,2001,'');

INSERT INTO `settlement_receipt` (`id`,`tenant_id`,`receipt_no`,`customer_id`,`receipt_type`,`currency`,`receipt_amount`,`receipt_time`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11302,1,'RCV202604240002',4203,'BANK','CNY',3924.000000,'2026-04-24 15:10:00.000','POSTED',2001,2001,''),
(11303,1,'RCV202604240003',4204,'BANK','CNY',2000.000000,'2026-04-24 19:20:00.000','POSTED',2001,2001,''),
(11304,1,'RCV202604240004',4203,'BANK','CNY',3378.700000,'2026-04-24 19:00:00.000','POSTED',2001,2001,'');

INSERT INTO `settlement_statement` (`id`,`tenant_id`,`statement_no`,`counterparty_type`,`counterparty_id`,`period_start`,`period_end`,`statement_amount`,`confirmed_amount`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11402,1,'STM202604240002','SUPPLIER',4003,'2026-04-01','2026-04-30',4796.000000,4796.000000,'CONFIRMED',2001,2001,''),
(11403,1,'STM202604240003','CUSTOMER',4203,'2026-04-01','2026-04-30',7302.700000,7302.700000,'CONFIRMED',2001,2001,'');

INSERT INTO `settlement_invoice` (`id`,`tenant_id`,`invoice_no`,`counterparty_type`,`counterparty_id`,`invoice_type`,`invoice_amount`,`tax_amount`,`invoice_date`,`status`,`created_by`,`updated_by`,`remark`) VALUES
(11502,1,'INV202604240002','CUSTOMER',4203,'VAT',3924.000000,324.000000,'2026-04-24','ISSUED',2001,2001,''),
(11503,1,'INV202604240003','CUSTOMER',4203,'VAT',3378.700000,388.700000,'2026-04-24','ISSUED',2001,2001,'');

INSERT INTO `workflow_instance` (`id`,`tenant_id`,`instance_no`,`biz_type`,`biz_no`,`status`,`current_node`,`start_user_id`,`start_at`,`end_at`,`created_by`,`updated_by`,`remark`) VALUES
(12002,1,'WF202604240002','PURCHASE_ORDER','PO202604240003','COMPLETED','END',2002,'2026-04-24 11:30:00.000','2026-04-24 11:40:00.000',2002,2002,''),
(12003,1,'WF202604240003','SALES_ORDER','SO202604240004','COMPLETED','END',2004,'2026-04-24 12:10:00.000','2026-04-24 12:15:00.000',2004,2004,'');

INSERT INTO `workflow_task` (`id`,`tenant_id`,`instance_id`,`node_code`,`task_name`,`assignee_id`,`task_status`,`action`,`action_at`,`comment`,`created_by`,`updated_by`,`remark`) VALUES
(12102,1,12002,'MANAGER_APPROVE','采购经理审批',2001,'DONE','APPROVE','2026-04-24 11:40:00.000','审批通过',2002,2002,''),
(12103,1,12003,'SALES_APPROVE','销售经理审批',2001,'DONE','APPROVE','2026-04-24 12:15:00.000','审批通过',2004,2004,'');

INSERT INTO `integration_idempotent` (`id`,`tenant_id`,`idempotent_key`,`biz_type`,`biz_no`,`request_hash`,`status`,`response_snapshot`,`expired_at`,`created_at`,`updated_at`) VALUES
(13002,1,'IDEMP-EXT-FRESHGO-0001','SALES_ORDER','SO202604240003','sha256-demo-freshgo-1','SUCCESS',JSON_OBJECT('soNo','SO202604240003','status','APPROVED'),'2026-05-24 00:00:00.000','2026-04-24 12:00:00.000','2026-04-24 12:00:00.000'),
(13003,1,'IDEMP-EXT-UNI-0001','SALES_ORDER','SO202604240004','sha256-demo-uni-1','SUCCESS',JSON_OBJECT('soNo','SO202604240004','status','APPROVED'),'2026-05-24 00:00:00.000','2026-04-24 12:20:00.000','2026-04-24 12:20:00.000');

INSERT INTO `event_outbox` (`id`,`tenant_id`,`event_id`,`aggregate_type`,`aggregate_id`,`event_type`,`biz_no`,`payload_json`,`status`,`retry_count`,`next_retry_at`,`published_at`,`created_at`,`updated_at`) VALUES
(13103,1,'EVT-SO-8003-CREATED','sales_order','8003','sales.order.created','SO202604240003',JSON_OBJECT('soNo','SO202604240003','customerId',4203),'PUBLISHED',0,NULL,'2026-04-24 12:01:00.000','2026-04-24 12:00:00.000','2026-04-24 12:01:00.000'),
(13104,1,'EVT-SO-8004-CREATED','sales_order','8004','sales.order.created','SO202604240004',JSON_OBJECT('soNo','SO202604240004','customerId',4204),'PUBLISHED',0,NULL,'2026-04-24 12:21:00.000','2026-04-24 12:20:00.000','2026-04-24 12:21:00.000'),
(13105,1,'EVT-GR-7405-COMPLETED','purchase_receipt','7405','purchase.receipt.completed','GR202604240005',JSON_OBJECT('receiptNo','GR202604240005','warehouseId',5003),'PUBLISHED',0,NULL,'2026-04-24 18:06:00.000','2026-04-24 18:00:00.000','2026-04-24 18:06:00.000');

INSERT INTO `integration_api_log` (`id`,`tenant_id`,`biz_type`,`biz_no`,`interface_name`,`direction`,`request_uri`,`request_body`,`response_body`,`status`,`error_msg`,`request_at`,`response_at`) VALUES
(13202,1,'SALES_ORDER','SO202604240003','freshgo.order.push','IN','/api/open/orders',JSON_OBJECT('sourceOrderNo','EXT-FRESHGO-0001','items',1),JSON_OBJECT('code',0,'message','ok'),'SUCCESS','', '2026-04-24 11:59:59.000','2026-04-24 12:00:00.000'),
(13203,1,'SALES_ORDER','SO202604240004','uni.order.push','IN','/api/open/orders',JSON_OBJECT('sourceOrderNo','EXT-UNI-0001','items',1),JSON_OBJECT('code',0,'message','ok'),'SUCCESS','', '2026-04-24 12:19:59.000','2026-04-24 12:20:00.000');

INSERT INTO `sys_audit_log` (`id`,`tenant_id`,`user_id`,`module`,`action`,`biz_type`,`biz_no`,`request_uri`,`request_ip`,`before_json`,`after_json`,`created_at`) VALUES
(14003,1,2002,'PURCHASE','CREATE_PO','PURCHASE_ORDER','PO202604240003','/api/purchase/orders','10.10.10.21',NULL,JSON_OBJECT('poNo','PO202604240003','status','APPROVED'),'2026-04-24 11:40:00.000'),
(14004,1,2004,'SALES','CREATE_SO','SALES_ORDER','SO202604240003','/api/sales/orders','10.10.10.23',NULL,JSON_OBJECT('soNo','SO202604240003','status','APPROVED'),'2026-04-24 12:00:00.000'),
(14005,1,2003,'WMS','SHIP','SALES_DELIVERY','DO202604240004','/api/wms/outbound/ship','10.10.10.24',NULL,JSON_OBJECT('deliveryNo','DO202604240004','status','SHIPPED'),'2026-04-24 18:50:00.000');

INSERT INTO `sys_login_log` (`id`,`tenant_id`,`user_id`,`username`,`login_ip`,`login_result`,`user_agent`,`created_at`) VALUES
(14103,1,2002,'buyer.east','10.10.10.21','SUCCESS','Mozilla/5.0 DemoBrowser','2026-04-24 11:20:00.000'),
(14104,1,2003,'wms.south','10.10.10.24','SUCCESS','Mozilla/5.0 DemoBrowser','2026-04-24 17:50:00.000');

INSERT INTO `sys_operate_log` (`id`,`tenant_id`,`user_id`,`module`,`operate_type`,`request_method`,`request_uri`,`request_body`,`response_body`,`latency_ms`,`status`,`created_at`) VALUES
(14203,1,2002,'PURCHASE','RECEIVE','POST','/api/purchase/receipts',JSON_OBJECT('receiptNo','GR202604240003'),JSON_OBJECT('code',0,'message','success'),112,'SUCCESS','2026-04-24 16:30:00.000'),
(14204,1,2004,'SALES','CREATE_ORDER','POST','/api/sales/orders',JSON_OBJECT('soNo','SO202604240006'),JSON_OBJECT('code',0,'message','success'),105,'SUCCESS','2026-04-24 13:00:00.000'),
(14205,1,2003,'WMS','PICK','POST','/api/wms/pick/confirm',JSON_OBJECT('taskNo','PK202604240004'),JSON_OBJECT('code',0,'message','success'),88,'SUCCESS','2026-04-24 18:40:00.000');

COMMIT;
