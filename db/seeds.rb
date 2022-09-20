# frozen_string_literal: true

users = [
  {
    email: 'elvis1@gmail.com',
    password_digest: '$2a$12$oaKg06NgGvsx4Ukp3/EUgeILOBN0rQtA2l8HFdzN1iRRBDlzvmG9O',
    tax_id: 'OIAE940228FR1'
  },
  { email: 'elvis2@gmail.com',
    password_digest: '$2a$12$oaKg06NgGvsx4Ukp3/EUgeILOBN0rQtA2l8HFdzN1iRRBDlzvmG9O',
    tax_id: 'OIAE940228FR2' }

]

User.create(users)
