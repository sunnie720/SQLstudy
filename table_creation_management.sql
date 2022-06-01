/* ���̺� ������ ���� */
-- ���̺� ����(CREATE TABLE)
-- CREATE TABLE ���̺��̸� (���̸� data_type(n) [DEFAULT]);
-- CREATE TABLE ���̺��̸� AS SELECT~; (a.k.a CTAS)

-- ���̺� ���� ����(ALTER TABLE)
-- �� �߰�: ALTER TABLE ���̺��̸� ADD (���̸� data_type(n) [DEFAULT]); 
-- �� ����: ALTER TABLE ���̺��̸� MODIFY (���̸� data_type(n));
-- �� ����: ALTER TABLE ���̺��̸� DROP COLUMN ���̸�;
-- ���̸� ����: ALTER TABLE ���̺��̸� RENAME COLUMN �������̸� TO �����̸�;
-- SET UNUSED: ���߿� ������ �� �ֵ��� "������ �ʾ���"���� ǥ��. ������ ��ó�� �ν�
---- �ش� ���� USER_UNUSED_COL_TABS��� ��ųʸ� �信 ���� (SET USED�� ����X)
-- ALTER TABLE ���̺��̸� SET UNUSED (���̸�);
-- DROP UNUSED COLUMNS: "UNUSED"�� ǥ�õ� �� ����
-- ALTER TABLE ���̺��̸� DROP UNUSED COLUMNS;

-- ��ü(���̺�) �̸� ����: RENAME �������̺��̸� TO �����̺��̸�;

-- ���̺� ����(DROP TABLE)
-- DROP TABLE ���̺��̸� [CASCADE CONSTRAINTS];
-- CASCADE CONSTRAINTS: ���� ���������� �ִ� ���� �����ϴ��� ���̺� ����

-- ���̺� ������ ����(TRUNCATE)
-- TRUNCATE TABLE ���̺��̸�;
-- �����ʹ� ���������� ���̺� ������ �������� ����
---- DELETE         : �൥���� ����, ���̺��� ����X, �ѹ� ����
---- TRUNCATE TABLE : �൥���� ����, ���̺��� ����X, �ѹ� �Ұ���
---- DROP TABLE     : ���̺���(�ε���,��������,���� �� ����) ����, �ѹ� �Ұ���

/* �������� */
--1. member���̺�: ����ھ��̵�(15), �̸�(20), ��й�ȣ(20), ��ȭ��ȣ(15), �̸���(100)
CREATE TABLE member (
    user_id     varchar2(15)    NOT NULL,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );

--2. ����ھ��̵�, �̸�, ��й�ȣ, ��ȭ��ȣ, �̸��� ����
-- user123, �����, a1234567890, 011-234-5678, user@user.com
INSERT INTO member 
    VALUES ('user123', '�����', 'a1234567890', '011-234-5678', 'user@user.com');

--3. ����ھ��̵� user123�� ������� ��� ���� ��ȸ
SELECT * 
FROM member
WHERE user_id='user123';

--4. ����ھ��̵� user123�� ������� �̸�, ��й�ȣ, ��ȭ��ȣ, �̸��� ����
-- ȫ�浿, a1234, 011-222-3333, user@user.co.kr
UPDATE member 
SET name='ȫ�浿', password='a1234', 
    phone='011-222-3333', email='user@user.co.kr'
WHERE user_id='user123';

--5. ����ھ��̵� user123�̰� ��й�ȣ�� a1234�� ȸ���� ���� ����
DELETE FROM member
WHERE user_id='user123' and password='a1234';

--6. member���̺� ��� �� ���� (TRUNCATE �̿�)
TRUNCATE TABLE member;
SELECT * FROM member;

--7. member���̺� ����
DROP TABLE member;