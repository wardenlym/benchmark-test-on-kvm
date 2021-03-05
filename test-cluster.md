
```
IP               Hostname        User/Passwd            CPU/Mem/Disk    Role
172.29.40.27                     jishu/Jishu*123qwe!    64c 256g 10Tb   vm-host/nginx-proxy
172.29.50.30     node-00         ubuntu/ubuntu          2c 4g 200Gb     haproxy
172.29.50.31     master-01       ubuntu/ubuntu          4c 8g 200Gb     master
172.29.50.32     master-02       ubuntu/ubuntu          4c 8g 200Gb     master
172.29.50.33     master-03       ubuntu/ubuntu          4c 8g 200Gb     master
172.29.50.41     worker-01       ubuntu/ubuntu          4c 8g 200Gb     worker
172.29.50.42     worker-02       ubuntu/ubuntu          4c 8g 200Gb     worker
172.29.50.43     worker-03       ubuntu/ubuntu          4c 8g 200Gb     worker
172.29.50.44     worker-04       ubuntu/ubuntu          8c 16g 200Gb    worker/monitor
```
rancher: https://172.29.40.27/ admin/admin

- admin kubeconfig

```yaml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1ETXdOVEF3TkRRMU1sb1hEVE14TURNd016QXdORFExTWxvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTzgwCkpUWHV5WTM5R2hSdFFzd28raE1qV3dmVUI4bUVnTkNRdkJNby9GRzNCM1ZTdVFTZ1NWYTQ0OGV6NHV1UW9NcC8KTjMvQURLR2RWdExBaGF4dWt2aHl2YzlWZUppWDBHL3lhL3pCWUEvd0lGVVpxUGwwRFM5TEJ3RWJwT2JVNkxCbApHaUw2MGp5ejNRK3ZyT1NYem54VFJMbWhjZVh6SVM5VDZCTlBiWDZtT2NPTGdySGRwcitnaVBmWDVRRzhXQ0dBCklFOEFLTCtFQm5LTFoyZ0ErVkRzSVlOeGM4S21NYlNMYTdZVWZnMDI0NmVrZnk2R2l6cjIvVHZGc1RzNElnMSsKekZybTZKcFYzSVRtZXg4dkR4c0lIN1pqV1V4Q3dVM1dWaUc3WUQwNGlJSENVc0x6TXBOY0hoRHJoMHdHSnNUTApLS2xEMEZVaTJ4NlpKMFpxUktrQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZOZHJHWW9UY1NpdFJqcTdkRFJ1eGRIcWxpUGZNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBNmNhRUttTzVDaEx2SUtRTVhPYktpeXEyMFMyWWp3QXZFR2NBeWFuY3pCOHhGTUMrNgpMam1rRWlETUFqUmYwSi9pbGhzTGNqYjZjVHo3TUtqZ2QxdTh2SVR0aksxTGFuNUFOZzh2aklUMjBROTRERkEwClp5bE40d0RYeTZHVlJKSG52ODFaaTNJWnRqRVpPVVpwaTJySGl3bUFQeFhqL1lmSnhuVXRRYnhhcjVHQys1aUcKb0phTnlqejJnREZ5NFFZM2hVMGZ3S1ZJV0RWSXovb3Q4NjZTaklRM1IvZHFCUDdIbnZ0aFpReDVCTmkwUG9LUwowSlpEOFk1Q08zL0F0UVdZUkJuUE1sSW5IWFhCL1BDaGZNSmRqRmdIM3RBOUZsMEp5a3BBeWF4c2pMdS9jMU5NCjd6QnZicTE2ZjFURTFGS0Qzb1c0MFJHdkU3YTk2YTN6OEFldgotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://172.29.50.30:6443
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJYXBCNzZ3akhNNzR3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBek1EVXdNRFEwTlRKYUZ3MHlNakF6TURVd01EUTBOVE5hTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQThyQWRuTy9Qc2ZZNmFyV3cKaHlYR09RbTRldklVRERJL3ExYlpvTE8yOFBJNnhSV3Z0cFYxRFR4S1JBeW5hTkprdE1wTlp6b3FFKzlaMStVNwpQUzZPaDlLOTJNdWJoK1VVSlh3czJvR1plazBLNjVTNlA3TUZUdG9iQkY5R2tsWnZkMDdCWExGVXUyM1pGTTNtCnM5YU8rYkFCRmE3SytxU1p3cGw2NEZzWStFalJxVVVEMk5iUVNxN0dtbjRnbzdGYkp1OXlIbkYzR2JvbWVKcVAKQkRSK2labThUWHp1OGJUd3V6NGpYd1ljaFlGZ2dNSWhEaGxUOERWdlZPL3VEK3lGaDUwaW1hbEwwVVVPaU5iLwovWE9rWFM0dFFHNTJ5OGgwQWh0R0gvbWQ2c2FZcmExMkhMTlBMajhUblhlY2w3eDFrRzVHUTMrRTl4M1dud0EwClA0U3FoUUlEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVUxMnNaaWhOeEtLMUdPcnQwTkc3RjBlcVdJOTh3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFPWC9wdjlFUEtDdGx5Wkx5WENTUmIyOGlveXByOEg1dFhJM0lPb2QxQkxieXRvaU5TMFR4a0pPCmVEMW9Zd3l4T29Xc0cyM3o3T2FiMTlHbkQ4ZkZpMmUvMlk5dFpBZnJyRVdZcXZaVHN5OVNHSVJVbUkwT3dUSXUKZUd4UTlIdWRmR08yTTQ3eEs2UHMvVFQyd0EwUHFxQWtNa2QwalRrc3QxQ3N2TCtCMVFJMUJ0bGxQQUtDRW9leApnUG9ndFdDOVB4TVd5UTZaTFc1bHFNVHpBMVQvMlFqcVliRzRhZHE5d1Y2b2xuLzdUNDJZekJyZ3ZialJYbVNGCjFmL2VHK2FtSTlCTjB1bmpleG1yUVB0czEyc2xHRlRYWVJqaVFpb1YrRXoza1FHRDdLZm5TeEo1NHhaWDlORmcKZ0xZYVZ3MDl5dFJMdHBrYzJVMXNaTTRsWDJEaFc1OD0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFb3dJQkFBS0NBUUVBOHJBZG5PL1BzZlk2YXJXd2h5WEdPUW00ZXZJVURESS9xMWJab0xPMjhQSTZ4Uld2CnRwVjFEVHhLUkF5bmFOSmt0TXBOWnpvcUUrOVoxK1U3UFM2T2g5SzkyTXViaCtVVUpYd3Myb0daZWswSzY1UzYKUDdNRlR0b2JCRjlHa2xadmQwN0JYTEZVdTIzWkZNM21zOWFPK2JBQkZhN0srcVNad3BsNjRGc1krRWpScVVVRAoyTmJRU3E3R21uNGdvN0ZiSnU5eUhuRjNHYm9tZUpxUEJEUitpWm04VFh6dThiVHd1ejRqWHdZY2hZRmdnTUloCkRobFQ4RFZ2Vk8vdUQreUZoNTBpbWFsTDBVVU9pTmIvL1hPa1hTNHRRRzUyeThoMEFodEdIL21kNnNhWXJhMTIKSExOUExqOFRuWGVjbDd4MWtHNUdRMytFOXgzV253QTBQNFNxaFFJREFRQUJBb0lCQUIxd2U4Y2oyQ0FRYkhteApYSjZvV0dsbTRuZ1hrWk1CTFhRTmJ3enRnQTJ1ZEs2ZnVOYi9QbG5DckllZ3VWWWYzNU9HenVqc3gxbnZ1UWhWCmlHQWRtN0NpUWVGZ29aZFVsS01QY3lsMmV6VzR6dEJSRkY3UnlwME1IQ2Jsbjl2MG5FVHV5c29Cd1BPVG1iZksKV21nS2FRR2s5aHk1UFdvMk9XaS8wWVlSeHUrbk9UcEw4RU91dTQ5SzNkVmhWM0JxR1BwR0kzQnBHWkNhdGJjWgpRdndBTEJRWm8wbGE1U2xOdXBkU1I1MXZjSmFRSU1pNVUwUDlYNndrcmJnUC9ub3ZyVGVTYWdBTlUydDVRcTRxCkVXT2R0eXpFMDhiU2ZBaFR2Vi9FRWo1VUFNTURNZURVcHlETVRvL3JZT2V5Nmwza1g2Qzd1d3BJckhUWFJYcUwKcVJYUW1Xa0NnWUVBODJnMDFRWVVwNzVFYWY5OTNEdEUrd21LYk5jNGVteHA4akkvVEd5cC83bVNnT1ZEbCtlWApvWWpmYTBIZ0FwTHh0d09PekMvdlpvNnFCUkZjcXczOUpIOFJQQkhrYm4wbGJTbHcrV0pEQ0ZzNXhHL3l3VnZMCndZakJPTytLYzJGTFI0Q2dtcGludXZVK0ZTcmlPRDNQRUE3Q2tsQndON0FhSEduRGNmMUliaGNDZ1lFQS96NWkKbVoxbXFyU0dSck5mSzQ1dmpQM05LekdRNWJIZ2hSc3M0enhQVHBEOHdSTWtkUHJ6Zy9rV2p1ZktJa0ZkNW1Mcgp0MXlBUE00Tk1Nc0Y0WDhRYjg1R0twYTdhaFkxK1J0K2cxMHk5NElOSDFlbjNJRHVxc0w3VUt1UVhOMzZyVFRUCmFXbUhrdzVmRHpqUi9oNVV4eXRrV2l3QU5UVGNuL0FJU0Z5V0NjTUNnWUJRR05SNTNSeGk3cXVZcmVoKzFrb20KeWNieGRna3gwQWMxR2UvV2VGT2d3VEpDbEM4Z0I2ZlFFamhqRlRSZjVIY0NJSHVYR1pjUUNwWk1RS0JiOGFpQgpvQWJOMjUxdDltU2dmV2lkeUFZQzgvSVlnRFpFQnE4UUtxNWF6QWlsV3pqb2VKMWhBaWIvMEwvek96OWgvb1RxCjVkQ0ZVVTc4SkVrVFhJSmlPbFRoVlFLQmdHSmYvZ3FzMHNRYVhlSmtBZHM4dzV1NHVsbmFlYms5eklZZ3lqVXUKcW5aaWhUZzVFNFVPcjhwK3Q0WU9xaVozd1NRcG5pWUd2ZG94cEgzWTBnUnVQN3lINlIxRENTckRNcnczTDVTYgoyQ2Z5OVBIT2pBRDlwSDhtTlV5TFExRzNzSVVQWmlncnB6Z3pnc25RSVlkcTAwd01XbG95dVVYSWdQd1h2R2wvClhjaVhBb0dCQUtHNURXTzIxVjR3UnhUU2Q5aVNyODRXbUtCWGhUcFN5akRQYWtOd2VPb3p2d2daMklCbFpMcWoKTllZNlM1ZnVyWjdPb1B6ZisyRit1RjJETDFWQzdTeEh0cWVodHhvMlc5OXdFTytwN20rZDlJQlY3N05NNVRhdApma0J2c1NWY3ljblhOS0dmSGk5SEVsOGdxUVpuZEtEOXN4aGRSdDFUUURJRjZGYjN4SGE1Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==
```