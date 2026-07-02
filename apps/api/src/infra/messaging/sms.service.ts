import config from '../../core/config';
import { _M_E_S_S_A_G_I_N_G__C_O_N_F_I_G, _M_E_S_S_A_G_I_N_G__M_E_S_S_A_G_E_S } from './messaging.constant';

export class SmsService {
    private accountSid: string;
    private authToken: string;
    private fromNumber: string;

    constructor() {
        this.accountSid = config.TWILIO_ACCOUNT_SID;
        this.authToken = config.TWILIO_AUTH_TOKEN;
        this.fromNumber = config.TWILIO_PHONE_NUMBER;
    }

    async sendSms(to: string, body: string): Promise<void> {
        const url = `${_M_E_S_S_A_G_I_N_G__C_O_N_F_I_G.TWILIO_URL_TEMPLATE}/${this.accountSid}/${_M_E_S_S_A_G_I_N_G__C_O_N_F_I_G.TWILIO_MESSAGES_ENDPOINT}`;
        const auth = Buffer.from(`${this.accountSid}:${this.authToken}`).toString('base64');

        const params = new URLSearchParams();
        params.append('From', this.fromNumber);
        params.append('To', to);
        params.append('Body', body);

        const response = await fetch(url, {
            method: 'POST',
            headers: {
                'Authorization': `Basic ${auth}`,
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: params.toString(),
        });

        if (!response.ok) {
            const errorData = await response.json() as any;
            throw new Error(`${_M_E_S_S_A_G_I_N_G__M_E_S_S_A_G_E_S.TWILIO_FAILED}: ${errorData.message || response.statusText}`);
        }
    }
}
