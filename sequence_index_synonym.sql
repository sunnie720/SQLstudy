--1. �Խ����� �Խñ� ��ȣ�� ���� ������
---- ����1) ������ �̸�: BBS_SEQ
---- ����2) �Խñ� ��ȣ�� 1�� ����
---- ����3) �������� 1���� �����ϸ� �ִ밪�� �������� ����
---- ����4) ĳ�� ������ 20��, ����Ŭ�� ���ġ ����
CREATE SEQUENCE bbs_seq
    INCREMENT BY 1
    START WITH 1
    CACHE 20
    NOCYCLE;
    
--2. ����� �޿� ���޾����� �˻�
---- �������� �ε��� ���� idx_emp_realsal
CREATE INDEX idx_emp_realsal
ON emps(COALESCE(salary+salary*commission_pct,salary));