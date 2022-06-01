/* ��������(Constraints) */
-- ���̺��� �ش� ���� ����ڰ� ��ġ ���� �����Ͱ� �Է�, ����, �����Ǵ� ���� �����ϱ� ���� ����
-- NOT NULL, UNIQUE, PRIMARY KEY, FOREIGN KEY, CHECK
-- ���̺� ���ǵ� �������� Ȯ��: USER_CONSTRAINTS ������ ��ųʸ�
---- SELECT * FROM USER_CONSTRAINTS;

-- �������� ����
-- ���̺� ���� ��������, �� ���� ��������
-- CREATE TABLE ���̺��̸� (���̸� data_type [DEFAULT] [����������], [���̺���������]);
-- �� ���� ��������
-- ... (���̸� data_type [DEFAULT] CONSTRAINT �������Ǹ� constraint_type);
-- ���̺� ���� ��������
-- ... CONSTRAINT ���̺��������Ǹ� constraint_type (���̸�);

-- �������� ����
-- �������� �߰�
-- ALTER TABLE ���̺��̸� ADD CONSTRAINT ���������̸� constraint_type (���̸�);
-- �������� ��ȸ
-- USER_CONSTRAINTS ������ ��ųʸ� �� Ȯ��  �Ǵ�
-- USER_CONSTRAINTS ���̺� ����
---- SELECT constraint_name, constraint_type, status 
---- FROM USER_CONSTRAINTS WHERE table_name='���̺��̸�';
---- SELECT * FROM USER_CONSTRAINTS;
-- �������� ��Ȱ��ȭ
-- ALTER TABLE ���̺��̸� DISABLE [NOVALIDATE | VALIDATE] CONSTRAINT �������Ǹ� [CASCADE];
---- DISABLE NOVALIDATE: �⺻��. �ش� ���� �������Ǹ� ���X
---- DISABLE VALIDATE: ���̺��� ������ ����(INSERT,UPDATE,DELETE)����
-- �������� Ȱ��ȭ
-- ALTER TABLE ���̺��̸� ENABLE [NOVALIDATE | VALIDATE] CONSTRAINT �������Ǹ�;
---- DISABLE NOVALIDATE: �̹� ������ �����ʹ� �������� üũX
---- DISABLE VALIDATE: �⺻��. �̹� ������ �����͵� �������� üũ (���� ���ϸ� �������� Ȱ��ȭ �Ұ�)

/* �������� */
--1. member ���̺� ���� -> ����� ���̵� PK
-- ����� ���̵�(15), �̸�(20), ��й�ȣ(20), ��ȭ��ȣ(15), �̸���(100)
CREATE TABLE member (
    user_id     varchar2(15)    PRIMARY KEY,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );
DROP TABLE member;
-- �Ǵ�
CREATE TABLE member (
    user_id     varchar2(15)    NOT NULL,
    name        varchar2(20)    NOT NULL,
    password    varchar2(20)    NOT NULL,
    phone       varchar2(15),
    email       varchar2(100)
    );
ALTER TABLE member
ADD CONSTRAINTS member_userid_pk PRIMARY KEY (user_id);
DROP TABLE member;

--2. ���̺� ���� �� �������� �߰�
-- DEPT ���̺��� DEPTNO���� ��Ű(PRIMARY KEY) ��. �������� �̸�: pk_dept
-- EMP ���̺��� EMPNO���� ��Ű(PRIMARY KEY) ��. �������� �̸�: pk_emp
-- EMP ���̺��� DEPTNO���� DEPT ���̺��� DEPTNO�� �����ϴ� �ܷ�Ű. �������� �̸�: fk_deptno
CREATE TABLE dept (
    deptno  number(2),
    dname   varchar2(14),
    loc     varchar2(13),
    CONSTRAINT pk_dept PRIMARY KEY(deptno)
);
CREATE TABLE emp (
    empno   number(4,0),
    ename   varchar2(10),
    job     varchar2(9),
    mgr     number(4,0),
    hiredate    date,
    sal     number(7,2),
    comm    number(7,2),
    deptno  number(2,0),
    CONSTRAINT pk_emp PRIMARY KEY(empno),
    CONSTRAINT fk_deptno FOREIGN KEY(deptno) REFERENCES dept(deptno)
);
