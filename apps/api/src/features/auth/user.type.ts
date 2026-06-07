type User = {
  readonly id: string;
  readonly name: string;
  readonly email: string;
  readonly phone_number: string;
  readonly avatar_url: string;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type UserLog = {
  readonly id: string;
  readonly uid: string;
  readonly type: string;
  readonly module: string;
  readonly title: string;
  readonly description: string;
  readonly meta: string;
  readonly ref_link: string;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type UserSession = {
  readonly id: string;
  readonly uid: string;
  readonly platform: string;
  readonly device_info: string;
  readonly ip_address: string;
  readonly status: boolean;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type UserAddress = {
  readonly id: string;
  readonly uid: string;
  readonly phone_number: string;
  readonly receiver_name: string;
  readonly type: string;
  readonly name: string;
  readonly street: string;
  readonly country_code: string;
  readonly country: string;
  readonly postal_code: string;
  readonly administrative_area: string;
  readonly sub_administrative_area: string;
  readonly locality: string;
  readonly sub_locality: string;
  readonly latitude: number;
  readonly longitude: number;
  readonly is_default: number;
  readonly created_at: Date;
  readonly updated_at: Date;
};

type OtpType = 'LOGIN' | 'RESET' | 'VERIFY';

type UserOtp = {
  readonly id: string;
  readonly actor: string;
  readonly otp: string;
  readonly type: OtpType;
  readonly valid_till: Date;
  readonly created_at: Date;
  readonly updated_at: Date;
};

export { User, UserLog, UserSession, UserAddress, UserOtp, OtpType };

